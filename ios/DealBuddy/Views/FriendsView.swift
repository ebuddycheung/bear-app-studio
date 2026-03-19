import SwiftUI

struct FriendsView: View {
    @StateObject private var viewModel = FriendsViewModel()
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search friends...", text: $searchText)
                        .textFieldStyle(.plain)
                        .onChange(of: searchText) { _, newValue in
                            Task {
                                await viewModel.searchUsers(query: newValue)
                            }
                        }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                
                // Tab selector
                HStack(spacing: 8) {
                    FriendTabButton(title: "All Friends", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    FriendTabButton(title: "Requests", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                    FriendTabButton(title: "Find", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                }
                .padding(.horizontal)
                
                // Content
                ScrollView {
                    if selectedTab == 0 {
                        FriendsListContent(friends: viewModel.friends, emptyMessage: "No friends yet", emptyIcon: "person.2")
                    } else if selectedTab == 1 {
                        RequestsContent(requests: viewModel.pendingRequests, onAccept: { request in
                            viewModel.acceptRequest(request)
                        }, onDecline: { request in
                            viewModel.declineRequest(request)
                        })
                    } else {
                        FindFriendsContent(users: viewModel.searchResults, searchText: searchText) { user in
                            viewModel.sendFriendRequest(to: user)
                        }
                    }
                }
            }
            .navigationTitle("👥 Friends")
        }
    }
}

struct FriendTabButton: View {
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

struct FriendsListContent: View {
    let friends: [FriendUser]
    let emptyMessage: String
    let emptyIcon: String
    
    var body: some View {
        if friends.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: emptyIcon)
                    .font(.system(size: 48))
                Text(emptyMessage)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 60)
        } else {
            LazyVStack(spacing: 0) {
                ForEach(friends) { friend in
                    FriendRow(friend: friend)
                }
            }
        }
    }
}

struct RequestsContent: View {
    let requests: [FriendRequest]
    let onAccept: (FriendRequest) -> Void
    let onDecline: (FriendRequest) -> Void
    
    var body: some View {
        if requests.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "person.crop.circle.badge.questionmark")
                    .font(.system(size: 48))
                Text("No pending requests")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 60)
        } else {
            LazyVStack(spacing: 0) {
                ForEach(requests) { request in
                    RequestRow(request: request, onAccept: { onAccept(request) }, onDecline: { onDecline(request) })
                }
            }
        }
    }
}

struct FindFriendsContent: View {
    let users: [FriendUser]
    let searchText: String
    let onAddFriend: (FriendUser) -> Void
    
    var body: some View {
        if users.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 48))
                Text("Search for friends")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 60)
        } else {
            LazyVStack(spacing: 0) {
                ForEach(users) { user in
                    FindUserRow(user: user, onAdd: { onAddFriend(user) })
                }
            }
        }
    }
}

struct FriendRow: View {
    let friend: FriendUser
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color(hex: "004E89"))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(friend.initial)
                            .font(.headline)
                            .foregroundColor(.white)
                    )
                
                Circle()
                    .fill(friend.status == "online" ? Color.green : Color.gray)
                    .frame(width: 12, height: 12)
                    .offset(x: 2, y: 2)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(friend.name)
                    .font(.headline)
                Text(friend.university)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        Divider()
    }
}

struct RequestRow: View {
    let request: FriendRequest
    let onAccept: () -> Void
    let onDecline: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: "004E89"))
                .frame(width: 48, height: 48)
                .overlay(
                    Text(request.initial)
                        .font(.headline)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(request.name)
                    .font(.headline)
                Text(request.timeAgo)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: onAccept) {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.green)
                        .clipShape(Circle())
                }
                
                Button(action: onDecline) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        Divider()
    }
}

struct FindUserRow: View {
    let user: FriendUser
    let onAdd: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: "004E89"))
                .frame(width: 48, height: 48)
                .overlay(
                    Text(user.initial)
                        .font(.headline)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.headline)
                Text(user.university)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: onAdd) {
                Image(systemName: "person.badge.plus")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color(hex: "FF6B35"))
                    .clipShape(Circle())
            }
        }
        .padding()
        Divider()
    }
}

#Preview {
    FriendsView()
}

// MARK: - Supporting Types

struct FriendUser: Identifiable {
    let id: UUID
    let name: String
    let university: String
    let initial: String
    let status: String
}

struct FriendRequest: Identifiable {
    let id: UUID
    let name: String
    let initial: String
    let timeAgo: String
}
