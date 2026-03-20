import SwiftUI
import Combine

// MARK: - Deep Link Manager
/// Manages deep linking for the app using URL scheme: dealbuddy://
/// 
/// Supported deep links:
/// - dealbuddy://deal/{dealId} - Opens a specific deal
/// - dealbuddy://profile/{userId} - Opens a user's profile
/// - dealbuddy://friends - Opens friends tab
class DeepLinkManager: ObservableObject {
    static let shared = DeepLinkManager()
    
    // Published properties for navigation
    @Published var pendingDeepLink: DeepLink?
    @Published var navigateToDeal: String?  // Deal ID to navigate to
    @Published var navigateToProfile: String?  // User ID to navigate to
    @Published var navigateToTab: AppTab?  // Tab to navigate to
    
    enum DeepLink: Equatable {
        case deal(id: String)
        case profile(id: String)
        case friends
        case leaderboard
    }
    
    enum AppTab: Int, CaseIterable {
        case home = 0
        case discover = 1
        case friends = 2
        case leaderboard = 3
        case chat = 4
        case profile = 5
    }
    
    private init() {}
    
    /// Handle incoming deep link URL
    func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              components.scheme == "dealbuddy" else {
            return
        }
        
        let host = components.host
        let path = components.path
        
        print("📲 DeepLinkManager: Handling \(url.absoluteString)")
        
        switch host {
        case "deal":
            // Extract deal ID from path (e.g., /abc123)
            let dealId = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            if !dealId.isEmpty {
                pendingDeepLink = .deal(id: dealId)
                navigateToDeal = dealId
                print("📲 DeepLinkManager: Navigating to deal: \(dealId)")
            }
            
        case "profile":
            let userId = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            if !userId.isEmpty {
                pendingDeepLink = .profile(id: userId)
                navigateToProfile = userId
                print("📲 DeepLinkManager: Navigating to profile: \(userId)")
            }
            
        case "friends":
            pendingDeepLink = .friends
            navigateToTab = .friends
            print("📲 DeepLinkManager: Navigating to friends tab")
            
        case "leaderboard":
            pendingDeepLink = .leaderboard
            navigateToTab = .leaderboard
            print("📲 DeepLinkManager: Navigating to leaderboard tab")
            
        default:
            print("📲 DeepLinkManager: Unknown deep link host: \(host ?? "nil")")
        }
    }
    
    /// Clear pending deep link after navigation
    func clearPendingDeepLink() {
        pendingDeepLink = nil
        navigateToDeal = nil
        navigateToProfile = nil
        navigateToTab = nil
    }
    
    /// Generate a shareable URL for a deal
    static func dealURL(for dealId: String) -> URL? {
        URL(string: "dealbuddy://deal/\(dealId)")
    }
    
    /// Generate a shareable URL for a profile
    static func profileURL(for userId: String) -> URL? {
        URL(string: "dealbuddy://profile/\(userId)")
    }
}
