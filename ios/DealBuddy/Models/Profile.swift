import Foundation

// MARK: - Profile Photo
struct ProfilePhoto: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let photoUrl: String
    var sortOrder: Int
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case photoUrl = "photo_url"
        case sortOrder = "sort_order"
        case createdAt = "created_at"
    }
}

// MARK: - User Profile
struct Profile: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var email: String?
    var name: String?
    var university: String?
    var bio: String?
    var avatarUrl: String?
    var photos: [ProfilePhoto]?
    var links: [ProfileLink]?
    var isPremium: Bool
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, email, name, university, bio
        case userId = "user_id"
        case avatarUrl = "avatar_url"
        case photos, links
        case isPremium = "is_premium"
        case createdAt = "created_at"
    }
    
    var initials: String {
        guard let name = name else { return "?" }
        let components = name.components(separatedBy: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1)).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }
}

// MARK: - Profile Links
struct ProfileLink: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let platform: LinkPlatform
    let url: String
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, platform, url
        case userId = "user_id"
        case createdAt = "created_at"
    }
}

// MARK: - App Link Platforms
enum LinkPlatform: String, Codable, CaseIterable {
    case instagram = "instagram"
    case twitter = "twitter"
    case portfolio = "portfolio"
    case linkedin = "linkedin"
    
    var icon: String {
        switch self {
        case .instagram: return "📸"
        case .twitter: return "🐦"
        case .portfolio: return "🌐"
        case .linkedin: return "💼"
        }
    }
    
    var displayName: String {
        switch self {
        case .instagram: return "Instagram"
        case .twitter: return "Twitter"
        case .portfolio: return "Portfolio"
        case .linkedin: return "LinkedIn"
        }
    }
}
