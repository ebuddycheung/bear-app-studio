import SwiftUI

struct DiscoverView: View {
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
                        DealsContent()
                    } else if selectedSubTab == 1 {
                        PartnersContent()
                    } else {
                        SpotsContent()
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
    var body: some View {
        VStack(spacing: 12) {
            DiscoverDealCard(
                title: "🍜 Ramen Special",
                originalPrice: "$45",
                discountedPrice: "$28",
                location: "Central",
                distance: "0.4km"
            )
            
            DiscoverDealCard(
                title: "🍕 Pizza Combo",
                originalPrice: "$55",
                discountedPrice: "$35",
                location: "Wan Chai",
                distance: "1.2km"
            )
        }
        .padding()
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
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("📚 Find Study Partners")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            PartnerCard(
                name: "Alex T.",
                subjects: "Math, Physics",
                university: "HKU",
                initial: "A"
            )
            
            PartnerCard(
                name: "Sarah L.",
                subjects: "English, History",
                university: "CUHK",
                initial: "S"
            )
            
            PartnerCard(
                name: "Mike C.",
                subjects: "CS, Data",
                university: "PolyU",
                initial: "M"
            )
        }
        .padding()
    }
}

struct PartnerCard: View {
    let name: String
    let subjects: String
    let university: String
    let initial: String
    
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
            
            Button(action: {}) {
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
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("☕ Study Spots")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            SpotCard(
                name: "Starbucks Central",
                details: "WiFi • Power outlets • Quiet",
                distance: "0.3km",
                icon: "☕"
            )
            
            SpotCard(
                name: "Central Library",
                details: "Free WiFi • Silent zone",
                distance: "0.6km",
                icon: "📚"
            )
            
            SpotCard(
                name: "Cozy Corner Cafe",
                details: "WiFi • Great food • Cozy",
                distance: "0.8km",
                icon: "🍜"
            )
        }
        .padding()
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
