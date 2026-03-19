import Foundation

// MARK: - Deal Model
struct Deal: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String?
    var originalPrice: Double?
    var discountedPrice: Double
    var category: DealCategory
    var locationName: String?
    var locationAddress: String?
    var latitude: Double?
    var longitude: Double?
    var expiresAt: Date?
    var isPromoted: Bool
    var createdBy: UUID?
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, title, description
        case originalPrice = "original_price"
        case discountedPrice = "discounted_price"
        case category
        case locationName = "location_name"
        case locationAddress = "location_address"
        case latitude, longitude
        case expiresAt = "expires_at"
        case isPromoted = "is_promoted"
        case createdBy = "created_by"
        case createdAt = "created_at"
    }
    
    var discountPercentage: Int? {
        guard let original = originalPrice, original > 0 else { return nil }
        return Int(((original - discountedPrice) / original) * 100)
    }
}

// MARK: - Deal Category
enum DealCategory: String, Codable, CaseIterable {
    case food
    case drinks
    case entertainment
    
    var icon: String {
        switch self {
        case .food: return "🍜"
        case .drinks: return "☕"
        case .entertainment: return "🎬"
        }
    }
    
    var displayName: String {
        switch self {
        case .food: return "Food"
        case .drinks: return "Drinks"
        case .entertainment: return "Entertainment"
        }
    }
}

// MARK: - Deal Claim
struct DealClaim: Identifiable, Codable {
    let id: UUID
    var dealId: UUID
    var userId: UUID
    var claimedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case dealId = "deal_id"
        case userId = "user_id"
        case claimedAt = "claimed_at"
    }
}

// MARK: - Mock Data for Development
extension Deal {
    static let mockDeals: [Deal] = [
        Deal(
            id: UUID(),
            title: "🍔 50% Off Burger Set",
            description: "Great burgers at half price!",
            originalPrice: 12.0,
            discountedPrice: 6.99,
            category: .food,
            locationName: "Central Burger Co.",
            locationAddress: "Central, Hong Kong",
            latitude: 22.2818,
            longitude: 114.1587,
            expiresAt: Date().addingTimeInterval(3 * 24 * 60 * 60),
            isPromoted: true,
            createdBy: nil,
            createdAt: Date()
        ),
        Deal(
            id: UUID(),
            title: "🍜 Ramen Special",
            description: "Authentic Japanese ramen",
            originalPrice: 45.0,
            discountedPrice: 28.0,
            category: .food,
            locationName: "Ramen House",
            locationAddress: "Central, Hong Kong",
            latitude: 22.2820,
            longitude: 114.1590,
            expiresAt: Date().addingTimeInterval(5 * 24 * 60 * 60),
            isPromoted: false,
            createdBy: nil,
            createdAt: Date()
        ),
        Deal(
            id: UUID(),
            title: "🎬 Cinema Ticket",
            description: "Standard movie ticket",
            originalPrice: 100.0,
            discountedPrice: 65.0,
            category: .entertainment,
            locationName: "AMC Cinema",
            locationAddress: "Wan Chai, Hong Kong",
            latitude: 22.2780,
            longitude: 114.1720,
            expiresAt: Date().addingTimeInterval(3 * 24 * 60 * 60),
            isPromoted: false,
            createdBy: nil,
            createdAt: Date()
        ),
        Deal(
            id: UUID(),
            title: "☕ Coffee 20% Off",
            description: "Any grande drink",
            originalPrice: 20.0,
            discountedPrice: 16.0,
            category: .drinks,
            locationName: "Starbucks Central",
            locationAddress: "Central, Hong Kong",
            latitude: 22.2825,
            longitude: 114.1585,
            expiresAt: Date().addingTimeInterval(2 * 24 * 60 * 60),
            isPromoted: false,
            createdBy: nil,
            createdAt: Date()
        )
    ]
}
