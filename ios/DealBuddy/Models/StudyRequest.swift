import Foundation

// MARK: - Study Request
struct StudyRequest: Identifiable, Codable {
    let id: UUID
    let fromUserId: UUID
    let toUserId: UUID
    let fromName: String
    let subject: String
    let message: String
    var status: StudyRequestStatus
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromUserId = "from_user_id"
        case toUserId = "to_user_id"
        case fromName = "from_name"
        case subject
        case message
        case status
        case createdAt = "created_at"
    }
}

enum StudyRequestStatus: String, Codable {
    case pending = "pending"
    case accepted = "accepted"
    case declined = "declined"
}

// MARK: - Study Connection
struct StudyConnection: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let connectedUserId: UUID
    let connectedUserName: String
    let subject: String
    let connectedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case connectedUserId = "connected_user_id"
        case connectedUserName = "connected_user_name"
        case subject
        case connectedAt = "connected_at"
    }
}
