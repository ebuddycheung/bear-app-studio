import Foundation

// MARK: - Chat ViewModel
@MainActor
final class ChatViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadMockData()
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        // TODO: Load real conversations
        
        loadMockData()
        
        isLoading = false
    }
    
    private func loadMockData() {
        conversations = [
            Conversation(
                id: UUID(),
                participantName: "Alex T.",
                participantInitial: "A",
                lastMessage: "Hey, want to study together?",
                timeAgo: "2m",
                unreadCount: 1
            ),
            Conversation(
                id: UUID(),
                participantName: "Sarah L.",
                participantInitial: "S",
                lastMessage: "Thanks for the deal tip!",
                timeAgo: "1h",
                unreadCount: 0
            ),
            Conversation(
                id: UUID(),
                participantName: "Mike C.",
                participantInitial: "M",
                lastMessage: "See you at the library!",
                timeAgo: "3h",
                unreadCount: 0
            )
        ]
    }
}

// MARK: - Conversation
struct Conversation: Identifiable {
    let id: UUID
    let participantName: String
    let participantInitial: String
    let lastMessage: String
    let timeAgo: String
    let unreadCount: Int
}
