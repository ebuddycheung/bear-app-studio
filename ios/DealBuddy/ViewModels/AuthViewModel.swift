import Foundation
import Supabase

// MARK: - Auth ViewModel
@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: Profile?
    
    init() {
        Task {
            await checkCurrentSession()
        }
    }
    
    func checkCurrentSession() async {
        if let user = SupabaseService.shared.currentUser {
            isAuthenticated = true
            await loadProfile(userId: user.id)
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let session = try await SupabaseService.shared.signIn(email: email, password: password)
            
            // User is not optional in the new SDK
            await loadProfile(userId: session.user.id)
            
            isAuthenticated = true
        } catch {
            errorMessage = "Sign in failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func signUp(email: String, password: String, name: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await SupabaseService.shared.signUp(email: email, password: password)
            
            // Try to sign in after signup (if email confirmation not required)
            // Otherwise, show message to check email
            do {
                let session = try await SupabaseService.shared.signIn(email: email, password: password)
                try await createProfile(userId: session.user.id, email: email, name: name)
                isAuthenticated = true
            } catch {
                // Email confirmation required
                errorMessage = "Please check your email to confirm your account."
            }
        } catch {
            errorMessage = "Sign up failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func createProfile(userId: UUID, email: String, name: String) async throws {
        let newProfile = Profile(
            id: UUID(),
            userId: userId,
            email: email,
            name: name,
            university: nil,
            bio: nil,
            avatarUrl: nil,
            isPremium: false,
            createdAt: Date()
        )
        
        try await SupabaseService.shared.client.from("profiles").insert(newProfile).execute()
    }
    
    private func loadProfile(userId: UUID) async {
        do {
            let response = try await SupabaseService.shared.client.from("profiles")
                .select()
                .eq("user_id", value: userId.uuidString)
                .single()
                .execute()
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            currentUser = try decoder.decode(Profile.self, from: response.data)
        } catch {
            print("Error loading profile: \(error)")
        }
    }
    
    func signOut() async {
        do {
            try await SupabaseService.shared.signOut()
        } catch {
            print("Sign out error: \(error)")
        }
        
        currentUser = nil
        isAuthenticated = false
    }
}
