import SwiftUI

// MARK: - Content View
struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView(isLoggedIn: $authViewModel.isAuthenticated)
            } else {
                LoginView()
            }
        }
    }
}

// Main Tab View with Logout
struct MainTabView: View {
    @Binding var isLoggedIn: Bool
    @State private var selectedTab = 0
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    
    // Navigation state for deep linking
    @State private var navigationPath = NavigationPath()
    @State private var isLoadingDeal = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(navigationPath: $navigationPath)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
                .onAppear {
                    checkForPendingDeepLink()
                }
            
            DiscoverView(navigationPath: $navigationPath)
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            FriendsView()
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }
                .tag(2)
            
            LeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: "trophy.fill")
                }
                .tag(3)
            
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
                .tag(4)
            
            ProfileView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(5)
        }
        .tint(Color(hex: "FF6B35"))
        .onAppear {
            // Request notification permission on first launch
            Task {
                await notificationManager.requestAuthorization()
            }
            
            // Handle any pending deep link
            checkForPendingDeepLink()
        }
        .onChange(of: deepLinkManager.navigateToDeal) { newDealId in
            if let dealId = newDealId, !dealId.isEmpty {
                handleDealDeepLink(dealId: dealId)
            }
        }
        .onChange(of: deepLinkManager.navigateToTab) { newTab in
            if let tab = newTab {
                selectedTab = tab.rawValue
                deepLinkManager.clearPendingDeepLink()
            }
        }
        .onChange(of: deepLinkManager.navigateToProfile) { newUserId in
            if newUserId != nil {
                selectedTab = 5
                deepLinkManager.clearPendingDeepLink()
            }
        }
    }
    
    /// Check for pending deep link on appear
    private func checkForPendingDeepLink() {
        if let dealId = deepLinkManager.navigateToDeal, !dealId.isEmpty {
            handleDealDeepLink(dealId: dealId)
        } else if let tab = deepLinkManager.navigateToTab {
            selectedTab = tab.rawValue
            deepLinkManager.clearPendingDeepLink()
        }
    }
    
    /// Handle deal deep link - fetch and navigate to deal
    private func handleDealDeepLink(dealId: String) {
        Task {
            await MainActor.run {
                isLoadingDeal = true
            }
            
            do {
                // Try to parse the UUID
                if let uuid = UUID(uuidString: dealId) {
                    // Fetch deal from repository
                    if let deal = try await DealRepository.shared.fetchDeal(byId: uuid) {
                        await MainActor.run {
                            // Switch to Discover tab and navigate
                            selectedTab = 1
                            navigationPath.append(deal)
                            deepLinkManager.clearPendingDeepLink()
                            isLoadingDeal = false
                            print("📲 Navigated to deal: \(deal.title)")
                        }
                    } else {
                        await MainActor.run {
                            print("Deal not found: \(dealId)")
                            isLoadingDeal = false
                            deepLinkManager.clearPendingDeepLink()
                        }
                    }
                } else {
                    // Invalid UUID format
                    await MainActor.run {
                        print("Invalid deal ID format: \(dealId)")
                        isLoadingDeal = false
                        deepLinkManager.clearPendingDeepLink()
                    }
                }
            } catch {
                await MainActor.run {
                    print("Error fetching deal: \(error)")
                    isLoadingDeal = false
                    deepLinkManager.clearPendingDeepLink()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationManager.shared)
        .environmentObject(DeepLinkManager.shared)
}
