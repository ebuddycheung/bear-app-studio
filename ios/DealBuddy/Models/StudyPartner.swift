import Foundation

// MARK: - Study Partner
struct StudyPartner: Identifiable, Codable {
    let id: UUID
    var userId: UUID
    var profile: Profile?
    var subjects: [String]
    var availability: String
    var isAvailable: Bool
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case profile = "profile"
        case subjects
        case availability
        case isAvailable = "is_available"
        case createdAt = "created_at"
    }
}

// MARK: - Study Spot
struct StudySpot: Identifiable, Codable {
    let id: UUID
    var name: String
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var hasWifi: Bool
    var hasPowerOutlets: Bool
    var noiseLevel: NoiseLevel
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, name, address, latitude, longitude
        case hasWifi = "wifi"
        case hasPowerOutlets = "power_outlets"
        case noiseLevel = "noise_level"
        case createdAt = "created_at"
    }
    
    var amenities: [String] {
        var result: [String] = []
        if hasWifi { result.append("WiFi") }
        if hasPowerOutlets { result.append("Power outlets") }
        result.append(noiseLevel.displayName)
        return result
    }
}

// MARK: - Noise Level
enum NoiseLevel: String, Codable, CaseIterable {
    case quiet
    case moderate
    case loud
    
    var displayName: String {
        switch self {
        case .quiet: return "Quiet"
        case .moderate: return "Moderate"
        case .loud: return "Loud"
        }
    }
}

// MARK: - Mock Data
extension StudySpot {
    static let mockSpots: [StudySpot] = [
        StudySpot(
            id: UUID(),
            name: "Starbucks Central",
            address: "Central, Hong Kong",
            latitude: 22.2825,
            longitude: 114.1585,
            hasWifi: true,
            hasPowerOutlets: true,
            noiseLevel: .moderate,
            createdAt: Date()
        ),
        StudySpot(
            id: UUID(),
            name: "Central Library",
            address: "Central, Hong Kong",
            latitude: 22.2830,
            longitude: 114.1595,
            hasWifi: true,
            hasPowerOutlets: true,
            noiseLevel: .quiet,
            createdAt: Date()
        ),
        StudySpot(
            id: UUID(),
            name: "Cozy Corner Cafe",
            address: "Wan Chai, Hong Kong",
            latitude: 22.2780,
            longitude: 114.1720,
            hasWifi: true,
            hasPowerOutlets: false,
            noiseLevel: .moderate,
            createdAt: Date()
        )
    ]
}

extension StudyPartner {
    static let mockPartners: [StudyPartner] = [
        StudyPartner(
            id: UUID(),
            userId: UUID(),
            profile: Profile(
                id: UUID(),
                userId: UUID(),
                email: "alex@example.com",
                name: "Alex T.",
                university: "HKU",
                bio: "Math & Physics major",
                avatarUrl: nil,
                isPremium: false,
                createdAt: Date()
            ),
            subjects: ["Math", "Physics"],
            availability: "Weekdays",
            isAvailable: true,
            createdAt: Date()
        ),
        StudyPartner(
            id: UUID(),
            userId: UUID(),
            profile: Profile(
                id: UUID(),
                userId: UUID(),
                email: "sarah@example.com",
                name: "Sarah L.",
                university: "CUHK",
                bio: "English & History lover",
                avatarUrl: nil,
                isPremium: true,
                createdAt: Date()
            ),
            subjects: ["English", "History"],
            availability: "Weekends",
            isAvailable: true,
            createdAt: Date()
        ),
        StudyPartner(
            id: UUID(),
            userId: UUID(),
            profile: Profile(
                id: UUID(),
                userId: UUID(),
                email: "mike@example.com",
                name: "Mike C.",
                university: "PolyU",
                bio: "CS & Data Science",
                avatarUrl: nil,
                isPremium: false,
                createdAt: Date()
            ),
            subjects: ["Computer Science", "Data Science"],
            availability: "Anytime",
            isAvailable: true,
            createdAt: Date()
        )
    ]
}
