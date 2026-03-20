import SwiftUI
import UserNotifications

@main
struct DealBuddyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var deepLinkManager = DeepLinkManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(notificationManager)
                .environmentObject(deepLinkManager)
                .onOpenURL { url in
                    // Handle universal links and URL scheme
                    deepLinkManager.handleDeepLink(url)
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Set up notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // MARK: - Push Notification Registration
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Task { @MainActor in
            NotificationManager.shared.handleDeviceToken(deviceToken)
        }
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        Task { @MainActor in
            NotificationManager.shared.handleRegistrationError(error)
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        // Show notification even when app is in foreground
        return [.banner, .badge, .sound]
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        
        // Handle notification tap - navigate to relevant screen
        await handleNotificationAction(userInfo: userInfo)
    }
    
    private func handleNotificationAction(userInfo: [AnyHashable: Any]) async {
        // Parse notification payload and handle navigation
        // Common payload keys:
        // - "type": "deal", "message", "friend_request", "study_partner"
        // - "id": relevant ID for the content
        
        if let type = userInfo["type"] as? String {
            switch type {
            case "deal":
                // Navigate to deal detail
                if let dealId = userInfo["id"] as? String {
                    print("Navigate to deal: \(dealId)")
                    // Would post notification to navigate to deal
                }
            case "message":
                // Navigate to chat
                if let chatId = userInfo["id"] as? String {
                    print("Navigate to chat: \(chatId)")
                }
            case "friend_request":
                // Navigate to friends
                print("Navigate to friends requests")
            default:
                break
            }
        }
    }
}
