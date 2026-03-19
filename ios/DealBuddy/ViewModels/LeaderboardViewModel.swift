import Foundation

class LeaderboardViewModel: ObservableObject {
    @Published var dealLeaders: [LeaderboardEntry] = []
    @Published var studyLeaders: [LeaderboardEntry] = []
    @Published var currentUserRank: LeaderboardEntry?
    @Published var isLoading = false
    
    func loadData() async {
        await MainActor.run { isLoading = true }
        
        // Simulated data - in production, fetch from Supabase
        // Deal Hunters Leaderboard
        dealLeaders = [
            LeaderboardEntry(id: UUID(), userName: "Alex Chen", userInitial: "A", score: 42, rank: 1, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Sarah Kim", userInitial: "S", score: 38, rank: 2, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "James Lee", userInitial: "J", score: 35, rank: 3, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Emma Wong", userInitial: "E", score: 28, rank: 4, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Michael Ho", userInitial: "M", score: 24, rank: 5, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Lisa Park", userInitial: "L", score: 21, rank: 6, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "David Lam", userInitial: "D", score: 19, rank: 7, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Amy Ng", userInitial: "A", score: 15, rank: 8, isCurrentUser: false),
        ]
        
        // Study Streaks Leaderboard
        studyLeaders = [
            LeaderboardEntry(id: UUID(), userName: "Rachel Zhang", userInitial: "R", score: 15, rank: 1, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Kevin Chow", userInitial: "K", score: 12, rank: 2, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Jessica Liu", userInitial: "J", score: 10, rank: 3, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Tom Huang", userInitial: "T", score: 8, rank: 4, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Grace Xu", userInitial: "G", score: 7, rank: 5, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Chris Wu", userInitial: "C", score: 6, rank: 6, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Nina Gao", userInitial: "N", score: 5, rank: 7, isCurrentUser: false),
            LeaderboardEntry(id: UUID(), userName: "Ryan Cheng", userInitial: "R", score: 4, rank: 8, isCurrentUser: false),
        ]
        
        // Current user's rank
        currentUserRank = LeaderboardEntry(id: UUID(), userName: "You", userInitial: "Y", score: 22, rank: 5, isCurrentUser: true)
        
        await MainActor.run { isLoading = false }
    }
}
