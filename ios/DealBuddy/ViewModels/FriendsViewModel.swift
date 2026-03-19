import Foundation

class FriendsViewModel: ObservableObject {
    @Published var friends: [FriendUser] = []
    @Published var pendingRequests: [FriendRequest] = []
    @Published var searchResults: [FriendUser] = []
    @Published var isLoading = false
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        friends = [
            FriendUser(id: UUID(), name: "Alex Chen", university: "HKU", initial: "A", status: "online"),
            FriendUser(id: UUID(), name: "Sarah Kim", university: "CUHK", initial: "S", status: "offline"),
            FriendUser(id: UUID(), name: "James Lee", university: "HKUST", initial: "J", status: "online"),
            FriendUser(id: UUID(), name: "Emma Wong", university: "CityU", initial: "E", status: "offline"),
        ]
        
        pendingRequests = [
            FriendRequest(id: UUID(), name: "Mike Zhang", initial: "M", timeAgo: "2 hours ago"),
            FriendRequest(id: UUID(), name: "Lisa Park", initial: "L", timeAgo: "1 day ago"),
        ]
        
        searchResults = [
            FriendUser(id: UUID(), name: "David Lam", university: "HKU", initial: "D", status: "online"),
            FriendUser(id: UUID(), name: "Amy Ng", university: "CUHK", initial: "A", status: "offline"),
            FriendUser(id: UUID(), name: "Chris Wu", university: "PolyU", initial: "C", status: "online"),
        ]
    }
    
    func searchUsers(query: String) async {
        await MainActor.run { isLoading = true }
        
        // Simulated search - in production, fetch from Supabase
        // For now, filter mock results based on query
        if query.isEmpty {
            await MainActor.run { searchResults = [] }
        } else {
            await MainActor.run {
                searchResults = [
                    FriendUser(id: UUID(), name: "David Lam", university: "HKU", initial: "D", status: "online"),
                    FriendUser(id: UUID(), name: "Amy Ng", university: "CUHK", initial: "A", status: "offline"),
                    FriendUser(id: UUID(), name: "Chris Wu", university: "PolyU", initial: "C", status: "online"),
                ].filter { $0.name.lowercased().contains(query.lowercased()) }
            }
        }
        
        await MainActor.run { isLoading = false }
    }
    
    func sendFriendRequest(to user: FriendUser) {
        // In production, send to Supabase
        print("Friend request sent to \(user.name)")
        
        // Remove from search results
        searchResults.removeAll { $0.id == user.id }
    }
    
    func acceptRequest(_ request: FriendRequest) {
        // Accept friend request
        pendingRequests.removeAll { $0.id == request.id }
        
        // Add to friends
        let newFriend = FriendUser(
            id: request.id,
            name: request.name,
            university: "Unknown",
            initial: request.initial,
            status: "offline"
        )
        friends.append(newFriend)
    }
    
    func declineRequest(_ request: FriendRequest) {
        pendingRequests.removeAll { $0.id == request.id }
    }
    
    func removeFriend(_ friend: FriendUser) {
        friends.removeAll { $0.id == friend.id }
    }
}
