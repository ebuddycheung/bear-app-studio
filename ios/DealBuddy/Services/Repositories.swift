import Foundation
import Supabase

// MARK: - Deal Repository
final class DealRepository {
    static let shared = DealRepository()
    private let supabase = SupabaseService.shared.client
    
    private init() {}
    
    // MARK: - Fetch All Deals
    func fetchDeals() async throws -> [Deal] {
        // TODO: Replace mock data with actual API call when Supabase is configured
        /*
        let response: [Deal] = try await supabase
            .from("deals")
            .select()
            .order("created_at", ascending: false)
            .execute()
        return response
        */
        
        // Mock data for now
        return Deal.mockDeals
    }
    
    // MARK: - Fetch Promoted Deals
    func fetchPromotedDeals() async throws -> [Deal] {
        /*
        let response: [Deal] = try await supabase
            .from("deals")
            .select()
            .eq("is_promoted", value: true)
            .order("created_at", ascending: false)
            .execute()
        return response
        */
        
        return Deal.mockDeals.filter { $0.isPromoted }
    }
    
    // MARK: - Fetch Deals by Category
    func fetchDeals(category: DealCategory) async throws -> [Deal] {
        /*
        let response: [Deal] = try await supabase
            .from("deals")
            .select()
            .eq("category", value: category.rawValue)
            .order("created_at", ascending: false)
            .execute()
        return response
        */
        
        return Deal.mockDeals.filter { $0.category == category }
    }
    
    // MARK: - Fetch Nearby Deals
    func fetchNearbyDeals(latitude: Double, longitude: Double, radiusKm: Double = 5) async throws -> [Deal] {
        /*
        let response: [Deal] = try await supabase
            .from("deals")
            .select()
            .order("created_at", ascending: false)
            .execute()
        
        // Filter by distance
        return response.filter { deal in
            guard let lat = deal.latitude, let lon = deal.longitude else { return false }
            let distance = calculateDistance(lat1: latitude, lon1: longitude, lat2: lat, lon2: lon)
            return distance <= radiusKm
        }
        */
        
        return Deal.mockDeals.filter { !$0.isPromoted }
    }
    
    // MARK: - Claim Deal
    func claimDeal(dealId: UUID, userId: UUID) async throws -> DealClaim {
        /*
        let claim = DealClaim(
            id: UUID(),
            dealId: dealId,
            userId: userId,
            claimedAt: Date()
        )
        
        try await supabase
            .from("deal_claims")
            .insert(claim)
            .execute()
        
        return claim
        */
        
        // Mock response
        return DealClaim(
            id: UUID(),
            dealId: dealId,
            userId: userId,
            claimedAt: Date()
        )
    }
    
    // MARK: - Fetch Deal by ID
    func fetchDeal(byId id: UUID) async throws -> Deal? {
        /*
        let response: [Deal] = try await supabase
            .from("deals")
            .select()
            .eq("id", value: id.uuidString)
            .limit(1)
            .execute()
        return response.first
        */
        
        // Search in mock data
        return Deal.mockDeals.first { $0.id == id }
    }
    
    // MARK: - Create Deal
    func createDeal(_ deal: Deal) async throws -> Deal {
        /*
        try await supabase
            .from("deals")
            .insert(deal)
            .execute()
        */
        return deal
    }
    
    // MARK: - Helpers
    private func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let earthRadius = 6371.0 // km
        let dLat = (lat2 - lat1) * .pi / 180
        let dLon = (lon2 - lon1) * .pi / 180
        let a = sin(dLat/2) * sin(dLat/2) +
                cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180) *
                sin(dLon/2) * sin(dLon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        return earthRadius * c
    }
}

// MARK: - Study Partner Repository
final class StudyPartnerRepository {
    static let shared = StudyPartnerRepository()
    private let supabase = SupabaseService.shared.client
    
    private init() {}
    
    func fetchPartners() async throws -> [StudyPartner] {
        /*
        let response: [StudyPartner] = try await supabase
            .from("study_partners")
            .select("*, profile:profiles(*)")
            .eq("is_available", value: true)
            .execute()
        return response
        */
        return StudyPartner.mockPartners
    }
    
    func fetchPartner(subjects: [String]) async throws -> [StudyPartner] {
        // Filter mock data by subjects
        return StudyPartner.mockPartners.filter { partner in
            partner.subjects.contains { subjects.contains($0) }
        }
    }
}

// MARK: - Study Spot Repository
final class StudySpotRepository {
    static let shared = StudySpotRepository()
    private let supabase = SupabaseService.shared.client
    
    private init() {}
    
    func fetchSpots() async throws -> [StudySpot] {
        /*
        let response: [StudySpot] = try await supabase
            .from("study_spots")
            .select()
            .execute()
        return response
        */
        return StudySpot.mockSpots
    }
    
    func fetchNearbySpots(latitude: Double, longitude: Double, radiusKm: Double = 2) async throws -> [StudySpot] {
        return StudySpot.mockSpots
    }
}

// MARK: - Profile Repository
final class ProfileRepository {
    static let shared = ProfileRepository()
    private let supabase = SupabaseService.shared.client
    
    private init() {}
    
    // MARK: - Fetch Profile
    func fetchProfile(userId: UUID) async throws -> Profile? {
        /*
        let response: [Profile] = try await supabase
            .from("profiles")
            .select("*, photos:profile_photos(*), links:profile_links(*)")
            .eq("id", value: userId.uuidString)
            .limit(1)
            .execute()
        return response.first
        */
        
        // Return nil - actual implementation would fetch from Supabase
        return nil
    }
    
    // MARK: - Update Profile
    func updateProfile(userId: UUID, name: String?, university: String?, bio: String?) async throws {
        /*
        try await supabase
            .from("profiles")
            .update([
                "name": name,
                "university": university,
                "bio": bio,
                "updated_at": Date()
            ])
            .eq("id", value: userId.uuidString)
            .execute()
        */
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        print("✅ Profile updated: name=\(name ?? "nil"), university=\(university ?? "nil"), bio=\(bio ?? "nil")")
    }
    
    // MARK: - Upload Avatar
    func uploadAvatar(userId: UUID, imageData: Data) async throws -> String {
        /*
        let fileName = "\(userId.uuidString)/avatar.jpg"
        try await supabase.storage
            .from("avatars")
            .upload(fileName, data: imageData, options: FileOptions(contentType: "image/jpeg"))
        
        let publicURL = try supabase.storage
            .from("avatars")
            .getPublicURL(fileName)
        
        // Update profile with new avatar URL
        try await supabase
            .from("profiles")
            .update(["avatar_url": publicURL.path, "updated_at": Date()])
            .eq("id", value: userId.uuidString)
            .execute()
        
        return publicURL.path
        */
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return "avatar_placeholder.jpg"
    }
}
