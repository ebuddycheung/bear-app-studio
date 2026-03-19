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
