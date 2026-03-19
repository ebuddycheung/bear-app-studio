import Foundation
import Supabase

// MARK: - Supabase Credentials
struct SupabaseCredentials {
    static let projectUrl = "https://iajjtnapetvuvadylgfq.supabase.co"
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlhamp0bmFwZXR2dXZhZHlsZ2ZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM5MDE3NTUsImV4cCI6MjA4OTQ3Nzc1NX0.bqUxgZ1ATFCK1jqRBKXEcnpCKWg7ymnyEF0JEFPYxjU"
}

// MARK: - Supabase Client
final class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    private init() {
        // Configure Supabase client with actual project credentials
        client = SupabaseClient(
            supabaseURL: URL(string: SupabaseCredentials.projectUrl)!,
            supabaseKey: SupabaseCredentials.anonKey
        )
    }
    
    // MARK: - Authentication
    func signUp(email: String, password: String) async throws {
        // Sign up returns Session if email confirmation is not required
        _ = try await client.auth.signUp(email: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws -> Session {
        // Sign in returns Session
        return try await client.auth.signIn(email: email, password: password)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    var currentUser: User? {
        client.auth.currentSession?.user
    }
    
    var currentSession: Session? {
        client.auth.currentSession
    }
}

// MARK: - Auth Errors
enum AuthError: Error, LocalizedError {
    case emailConfirmationRequired
    case invalidCredentials
    case notAuthenticated
    
    var errorDescription: String? {
        switch self {
        case .emailConfirmationRequired:
            return "Email confirmation required. Please check your inbox."
        case .invalidCredentials:
            return "Invalid email or password."
        case .notAuthenticated:
            return "Not authenticated. Please sign in."
        }
    }
}
