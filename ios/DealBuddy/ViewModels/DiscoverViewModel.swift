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
    
    // Store unfiltered deals to avoid compounding filters
    private var allDeals: [Deal] = []
    
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
            let dealsResponse = try await SupabaseService.shared.client
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
                allDeals = fetchedDeals
                deals = fetchedDeals
            }
            
            // Fetch study spots
            let spotsResponse = try await SupabaseService.shared.client
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
            let partnersResponse = try await SupabaseService.shared.client
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
            // Always filter from the full unfiltered list to avoid compounding
            deals = allDeals.filter { $0.category == category }
        } else {
            // Show all deals
            deals = allDeals
        }
    }
    
    private func loadMockData() {
        allDeals = Deal.mockDeals
        deals = Deal.mockDeals
        partners = StudyPartner.mockPartners
        spots = StudySpot.mockSpots
    }
}
