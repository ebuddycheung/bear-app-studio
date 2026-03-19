import Foundation

// MARK: - User Profile
struct Profile: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    var email: String?
    var name: String?
    var university: String?
    var bio: String?
    var avatarUrl: String?
    var isPremium: Bool
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, email, name, university, bio
        case userId = "user_id"
        case avatarUrl = "avatar_url"
        case isPremium = "is_premium"
        case createdAt = "created_at"
    }
}

// MARK: - Profile Links
struct ProfileLink: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let platform: String
    let url: String
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, platform, url
        case userId = "user_id"
        case createdAt = "created_at"
    }
}

// MARK: - App Link Platforms
enum LinkPlatform: String, CaseIterable {
    case instagram = "instagram"
    case twitter = "twitter"
    case portfolio = "portfolio"

    var icon: String {
        switch self {
        case .instagram: return "📸"
        case .twitter: return "🐦"
        case .portfolio: return "💼"
        }
    }
}
