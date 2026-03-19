import Foundation

// MARK: - Discover ViewModel
@MainActor
final class DiscoverViewModel: ObservableObject {
    @Published var deals: [Deal] = []
    @Published var partners: [StudyPartner] = []
    @Published var spots: [StudySpot] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCategory: DealCategory?
    
    init() {
        Task {
            await loadData()
        }
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch deals from Supabase
            let dealsResponse = try await SupabaseService.shared.client.database
                .from("deals")
                .select()
                .order("created_at", ascending: false)
                .execute()
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let fetchedDeals = try decoder.decode([Deal].self, from: dealsResponse.data)
            
            if fetchedDeals.isEmpty {
                loadMockData()
            } else {
                deals = fetchedDeals
            }
            
            // Fetch study spots
            let spotsResponse = try await SupabaseService.shared.client.database
                .from("study_spots")
                .select()
                .execute()
            let fetchedSpots = try decoder.decode([StudySpot].self, from: spotsResponse.data)
            
            if !fetchedSpots.isEmpty {
                spots = fetchedSpots
            } else {
                spots = StudySpot.mockSpots
            }
            
            // Fetch study partners
            let partnersResponse = try await SupabaseService.shared.client.database
                .from("study_partners")
                .select()
                .execute()
            let fetchedPartners = try decoder.decode([StudyPartner].self, from: partnersResponse.data)
            
            if !fetchedPartners.isEmpty {
                partners = fetchedPartners
            } else {
                partners = StudyPartner.mockPartners
            }
            
        } catch {
            print("Error loading discover data: \(error)")
            loadMockData()
        }
        
        isLoading = false
    }
    
    func filterDeals(by category: DealCategory?) {
        selectedCategory = category
        if let category = category {
            deals = deals.filter { $0.category == category }
        } else {
            // Reload from database or mock
            Task {
                await loadData()
            }
        }
    }
    
    private func loadMockData() {
        deals = Deal.mockDeals
        partners = StudyPartner.mockPartners
        spots = StudySpot.mockSpots
    }
}
