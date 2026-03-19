import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab selector
                HStack(spacing: 8) {
                    LeaderboardTabButton(title: "🏆 Deal Hunters", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    LeaderboardTabButton(title: "📚 Study Streaks", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                }
                .padding()
                
                ScrollView {
                    if selectedTab == 0 {
                        DealHuntersContent(entries: viewModel.dealLeaders, currentUser: viewModel.currentUserRank)
                    } else {
                        StudyStreaksContent(entries: viewModel.studyLeaders, currentUser: viewModel.currentUserRank)
                    }
                }
            }
            .navigationTitle("🏆 Leaderboard")
            .onAppear {
                Task { await viewModel.loadData() }
            }
        }
    }
}

struct LeaderboardTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color(hex: "FF6B35") : Color.white)
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(16)
        }
    }
}

struct UserRankBanner: View {
    let rank: LeaderboardEntry?
    
    var body: some View {
        if let rank = rank {
            HStack(spacing: 12) {
                Text("#\(rank.rank)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "FF6B35"))
                
                Circle()
                    .fill(Color(hex: "004E89"))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(rank.userInitial)
                            .font(.headline)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading) {
                    Text("Your Rank")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(rank.userName)
                        .font(.headline)
                }
                
                Spacer()
                
                Text("\(rank.score) pts")
                    .font(.headline)
                    .foregroundColor(Color(hex: "FF6B35"))
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding()
        }
    }
}

struct DealHuntersContent: View {
    let entries: [LeaderboardEntry]
    let currentUser: LeaderboardEntry?
    
    var body: some View {
        VStack(spacing: 0) {
            UserRankBanner(rank: currentUser)
            
            LazyVStack(spacing: 0) {
                ForEach(entries) { entry in
                    LeaderboardRow(entry: entry, icon: "tag.fill")
                }
            }
        }
    }
}

struct StudyStreaksContent: View {
    let entries: [LeaderboardEntry]
    let currentUser: LeaderboardEntry?
    
    var body: some View {
        VStack(spacing: 0) {
            UserRankBanner(rank: currentUser)
            
            LazyVStack(spacing: 0) {
                ForEach(entries) { entry in
                    LeaderboardRow(entry: entry, icon: "book.fill")
                }
            }
        }
    }
}

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Rank
            Text("#\(entry.rank)")
                .font(.headline)
                .foregroundColor(entry.rank <= 3 ? Color(hex: "FF6B35") : .gray)
                .frame(width: 40)
            
            // Medal for top 3
            if entry.rank == 1 {
                Text("🥇")
            } else if entry.rank == 2 {
                Text("🥈")
            } else if entry.rank == 3 {
                Text("🥉")
            }
            
            // Avatar
            Circle()
                .fill(Color(hex: "004E89"))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(entry.userInitial)
                        .font(.subheadline)
                        .foregroundColor(.white)
                )
            
            // Name
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.userName)
                    .font(.headline)
                if entry.isCurrentUser {
                    Text("You")
                        .font(.caption)
                        .foregroundColor(Color(hex: "FF6B35"))
                }
            }
            
            Spacer()
            
            // Score
            VStack(alignment: .trailing) {
                Text("\(entry.score)")
                    .font(.headline)
                Text("pts")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(entry.isCurrentUser ? Color(hex: "FF6B35").opacity(0.1) : Color.clear)
        Divider()
    }
}

#Preview {
    LeaderboardView()
}

// MARK: - Supporting Types

struct LeaderboardEntry: Identifiable {
    let id: UUID
    let userName: String
    let userInitial: String
    let score: Int
    let rank: Int
    let isCurrentUser: Bool
}
