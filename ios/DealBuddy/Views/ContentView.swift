import SwiftUI

// MARK: - Content View
struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var notificationManager: NotificationManager
    
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
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            DiscoverView()
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
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(NotificationManager.shared)
}
