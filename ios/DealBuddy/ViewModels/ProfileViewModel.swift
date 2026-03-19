import Foundation
import Supabase

// MARK: - Profile ViewModel
@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var stats: UserStats = UserStats(deals: 0, sessions: 0, friends: 0)
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedIn = false
    
    init() {
        Task {
            await checkAuthStatus()
        }
    }
    
    func checkAuthStatus() async {
        if let user = SupabaseService.shared.currentUser {
            isLoggedIn = true
            await loadProfile(userId: user.id)
        } else {
            loadMockData()
        }
    }
    
    func loadProfile(userId: UUID? = nil) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let targetId = userId ?? SupabaseService.shared.currentUser?.id
            
            if let uid = targetId {
                let response = try await SupabaseService.shared.client.from("profiles")
                    .select()
                    .eq("user_id", value: uid.uuidString)
                    .single()
                    .execute()
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let fetchedProfile = try decoder.decode(Profile.self, from: response.data)
                profile = fetchedProfile
                isLoggedIn = true
            } else {
                loadMockData()
            }
        } catch {
            print("Error loading profile: \(error)")
            loadMockData()
        }
        
        isLoading = false
    }
    
    func updateProfile(name: String?, university: String?, bio: String?) async throws {
        guard let userId = SupabaseService.shared.currentUser?.id else {
            throw NSError(domain: "Profile", code: 401, userInfo: [NSLocalizedDescriptionKey: "Not logged in"])
        }
        
        var updates = ProfileUpdate()
        updates.name = name
        updates.university = university
        updates.bio = bio
        
        try await SupabaseService.shared.client.from("profiles")
            .update(updates)
            .eq("user_id", value: userId.uuidString)
            .execute()
        
        await loadProfile()
    }
    
    func logout() async {
        do {
            try await SupabaseService.shared.signOut()
            isLoggedIn = false
            profile = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func loadMockData() {
        profile = Profile(
            id: UUID(),
            userId: UUID(),
            email: "john.doe@example.com",
            name: "John Doe",
            university: "Hong Kong University",
            bio: "Student | Deal Hunter | Study Enthusiast",
            avatarUrl: nil,
            isPremium: true,
            createdAt: Date()
        )
        
        stats = UserStats(deals: 12, sessions: 5, friends: 8)
    }
}

// MARK: - User Stats
struct UserStats {
    var deals: Int
    var sessions: Int
    var friends: Int
}

// MARK: - Profile Update (for partial updates)
struct ProfileUpdate: Codable {
    var name: String?
    var university: String?
    var bio: String?
}
