import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @State private var selectedSubTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Sub-tabs
                HStack(spacing: 8) {
                    SubTabButton(title: "Deals", isSelected: selectedSubTab == 0) {
                        selectedSubTab = 0
                    }
                    SubTabButton(title: "Partners", isSelected: selectedSubTab == 1) {
                        selectedSubTab = 1
                    }
                    SubTabButton(title: "Study Spots", isSelected: selectedSubTab == 2) {
                        selectedSubTab = 2
                    }
                }
                .padding()
                
                // Content
                ScrollView {
                    if selectedSubTab == 0 {
                        DealsContent(deals: viewModel.deals)
                    } else if selectedSubTab == 1 {
                        PartnersContent(partners: viewModel.partners)
                    } else {
                        SpotsContent(spots: viewModel.spots)
                    }
                }
            }
            .background(Color(hex: "F7F7F7"))
            .navigationTitle("🔍 Discover")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.circle")
                }
            }
            .refreshable {
                await viewModel.loadData()
            }
        }
    }
}

struct SubTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(hex: "FF6B35") : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct DealsContent: View {
    let deals: [Deal]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(deals) { deal in
                DiscoverDealCard(
                    title: "\(deal.category.icon) \(deal.title)",
                    originalPrice: formatPrice(deal.originalPrice),
                    discountedPrice: formatPrice(deal.discountedPrice),
                    location: deal.locationName ?? "Unknown",
                    distance: "0.5km"
                )
            }
        }
        .padding()
    }
    
    private func formatPrice(_ price: Double?) -> String {
        guard let price = price else { return "$--" }
        return String(format: "$%.2f", price)
    }
}

struct DiscoverDealCard: View {
    let title: String
    let originalPrice: String
    let discountedPrice: String
    let location: String
    let distance: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text("\(location) • \(distance)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(discountedPrice)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "FF6B35"))
                
                Text(originalPrice)
                    .font(.caption)
                    .strikethrough()
                    .foregroundColor(.gray)
            }
            
            Button(action: {}) {
                Text("View")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(hex: "FF6B35"))
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct PartnersContent: View {
    let partners: [StudyPartner]
    @State private var selectedPartner: StudyPartner?
    @State private var showRequestSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📚 Find Study Partners")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            ForEach(partners) { partner in
                PartnerCard(
                    name: partner.profile?.name ?? "Unknown",
                    subjects: partner.subjects.joined(separator: ", "),
                    university: partner.profile?.university ?? "Unknown",
                    initial: String((partner.profile?.name ?? "U").prefix(1))
                ) {
                    selectedPartner = partner
                    showRequestSheet = true
                }
            }
        }
        .padding()
        .sheet(isPresented: $showRequestSheet) {
            if let partner = selectedPartner {
                StudyPartnerRequestView(partner: partner)
            }
        }
    }
}

struct PartnerCard: View {
    let name: String
    let subjects: String
    let university: String
    let initial: String
    let onConnect: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: "E8F4FD"))
                .frame(width: 48, height: 48)
                .overlay(Text(initial).font(.title3))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.headline)
                
                Text("📚 \(subjects) • 🎓 \(university)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: onConnect) {
                Text("Connect")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color(hex: "004E89"))
                    .cornerRadius(16)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct SpotsContent: View {
    let spots: [StudySpot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("☕ Study Spots")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            ForEach(spots) { spot in
                SpotCard(
                    name: spot.name,
                    details: spot.amenities.joined(separator: " • "),
                    distance: "0.5km",
                    icon: getIconForSpot(spot.name)
                )
            }
        }
        .padding()
    }
    
    private func getIconForSpot(_ name: String) -> String {
        let lowercaseName = name.lowercased()
        if lowercaseName.contains("starbucks") || lowercaseName.contains("coffee") || lowercaseName.contains("cafe") {
            return "☕"
        } else if lowercaseName.contains("library") {
            return "📚"
        } else {
            return "🍜"
        }
    }
}

struct SpotCard: View {
    let name: String
    let details: String
    let distance: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "E8F4FD"))
                .frame(width: 40, height: 40)
                .overlay(Text(icon).font(.title3))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.headline)
                
                Text(details)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(distance)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "FF6B35"))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    DiscoverView()
}
