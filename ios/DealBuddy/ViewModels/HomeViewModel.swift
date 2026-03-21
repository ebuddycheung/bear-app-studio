import Foundation

// MARK: - Home ViewModel
@MainActor
final class HomeViewModel: ObservableObject {
    @Published var promotedDeal: Deal?
    @Published var nearbyDeals: [Deal] = []
    @Published var recentActivity: [Activity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        // Start loading real data immediately
        Task {
            await loadData()
        }
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch deals from Supabase
            let response = try await SupabaseService.shared.client
                .from("deals")
                .select()
                .order("created_at", ascending: false)
                .execute()
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let deals = try decoder.decode([Deal].self, from: response.data)
            
            // Separate promoted and regular deals
            promotedDeal = deals.first(where: { $0.isPromoted })
            nearbyDeals = deals.filter { !$0.isPromoted }
            
            // If no deals in DB yet, use mock data for demo
            if deals.isEmpty {
                loadMockData()
            }
        } catch {
            print("Error loading deals: \(error)")
            // Fallback to mock data on error
            loadMockData()
        }
        
        isLoading = false
    }
    
    private func loadMockData() {
        let deals = Deal.mockDeals
        promotedDeal = deals.first(where: { $0.isPromoted })
        nearbyDeals = deals.filter { !$0.isPromoted }
        
        recentActivity = [
            Activity(name: "Alex", action: "claimed 🍔 Burger Deal", initial: "A"),
            Activity(name: "Sarah", action: "joined a Study Session", initial: "S"),
            Activity(name: "Mike", action: "found 🎬 Cinema Deal", initial: "M")
        ]
    }
}

// MARK: - Activity Model
struct Activity: Identifiable {
    let id = UUID()
    let name: String
    let action: String
    let initial: String
}
