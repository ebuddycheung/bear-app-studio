import Foundation

// MARK: - Friend
struct Friend: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var friendId: UUID
    var profile: Profile?
    var status: FriendStatus
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case friendId = "friend_id"
        case profile = "profile"
        case status
        case createdAt = "created_at"
    }
}

enum FriendStatus: String, Codable {
    case pending
    case accepted
    
    var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .accepted: return "Friends"
        }
    }
}

// MARK: - Message
struct Message: Identifiable, Codable {
    let id: UUID
    var senderId: UUID
    var senderProfile: Profile?
    var receiverId: UUID
    var receiverProfile: Profile?
    var content: String
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case senderId = "sender_id"
        case senderProfile = "sender_profile"
        case receiverId = "receiver_id"
        case receiverProfile = "receiver_profile"
        case content
        case createdAt = "created_at"
    }
}

// MARK: - Mock Data
extension Message {
    static let mockMessages: [Message] = [
        Message(
            id: UUID(),
            senderId: UUID(),
            senderProfile: Profile(
                id: UUID(),
                userId: UUID(),
                email: "alex@example.com",
                name: "Alex T.",
                university: "HKU",
                bio: nil,
                avatarUrl: nil,
                isPremium: false,
                createdAt: Date()
            ),
            receiverId: UUID(),
            receiverProfile: nil,
            content: "Hey, want to study together?",
            createdAt: Date().addingTimeInterval(-2 * 60)
        ),
        Message(
            id: UUID(),
            senderId: UUID(),
            senderProfile: Profile(
                id: UUID(),
                userId: UUID(),
                email: "sarah@example.com",
                name: "Sarah L.",
                university: "CUHK",
                bio: nil,
                avatarUrl: nil,
                isPremium: true,
                createdAt: Date()
            ),
            receiverId: UUID(),
            receiverProfile: nil,
            content: "Thanks for the deal tip!",
            createdAt: Date().addingTimeInterval(-1 * 60 * 60)
        ),
        Message(
            id: UUID(),
            senderId: UUID(),
            senderProfile: Profile(
                id: UUID(),
                userId: UUID(),
                email: "mike@example.com",
                name: "Mike C.",
                university: "PolyU",
                bio: nil,
                avatarUrl: nil,
                isPremium: false,
                createdAt: Date()
            ),
            receiverId: UUID(),
            receiverProfile: nil,
            content: "See you at the library!",
            createdAt: Date().addingTimeInterval(-3 * 60 * 60)
        )
    ]
}
