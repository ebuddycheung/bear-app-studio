import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showCreateDeal = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Promoted Section
                    if let promoted = viewModel.promotedDeal {
                        VStack(alignment: .leading) {
                            Text("🔥 Promoted")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            PromotedDealCard(deal: promoted)
                        }
                    }
                    
                    // Friends Activity
                    VStack(alignment: .leading) {
                        Text("👥 Friends Activity")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        VStack(spacing: 0) {
                            ForEach(viewModel.recentActivity) { activity in
                                ActivityRow(name: activity.name, action: activity.action, initial: activity.initial)
                                if activity.id != viewModel.recentActivity.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    
                    // Nearby Deals
                    VStack(alignment: .leading) {
                        Text("📍 Nearby Deals")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        ForEach(viewModel.nearbyDeals) { deal in
                            DealCard(
                                title: "\(deal.category.icon) \(deal.title)",
                                originalPrice: formatPrice(deal.originalPrice),
                                discountedPrice: formatPrice(deal.discountedPrice),
                                discount: deal.discountPercentage.map { "-\($0)%" } ?? "",
                                distance: "0.5km",
                                expiry: formatExpiry(deal.expiresAt)
                            )
                        }
                    }
                }
                .padding()
            }
            .background(Color(hex: "F7F7F7"))
            .navigationTitle("🐻 DealBuddy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Button(action: { showCreateDeal = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                        }
                        Image(systemName: "bell")
                        Image(systemName: "person.circle")
                    }
                }
            }
            .sheet(isPresented: $showCreateDeal) {
                CreateDealView()
            }
            .refreshable {
                await viewModel.loadData()
            }
        }
    }
    
    private func formatPrice(_ price: Double?) -> String {
        guard let price = price else { return "$--" }
        return String(format: "$%.2f", price)
    }
    
    private func formatExpiry(_ date: Date?) -> String {
        guard let date = date else { return "No expiry" }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
        if days == 0 {
            return "Expires today"
        } else if days == 1 {
            return "Expires tomorrow"
        } else {
            return "Expires in \(days) days"
        }
    }
}

struct PromotedDealCard: View {
    let deal: Deal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("⭐ PROMOTED")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "FFD700"))
                    .cornerRadius(4)
                
                Spacer()
                
                Text(String(format: "$%.2f", deal.discountedPrice))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "FFD700"))
                +
                Text(" \(formatPrice(deal.originalPrice))")
                    .font(.body)
                    .strikethrough()
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text(deal.title)
                .font(.headline)
                .foregroundColor(.white)
            
            if let location = deal.locationName {
                Text("Just 0.3km away at \(location)! Limited time")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Button(action: {}) {
                Text("Claim Now →")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "004E89"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(hex: "FFD700"))
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color(hex: "004E89"), Color(hex: "0077B6")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }
    
    private func formatPrice(_ price: Double?) -> String {
        guard let price = price else { return "$--" }
        return String(format: "$%.2f", price)
    }
}

struct ActivityRow: View {
    let name: String
    let action: String
    let initial: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: "E8F4FD"))
                .frame(width: 36, height: 36)
                .overlay(Text(initial).font(.system(size: 14)))
            
            Text("\(name) \(action)")
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

struct DealCard: View {
    let title: String
    let originalPrice: String
    let discountedPrice: String
    let discount: String
    let distance: String
    let expiry: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text(discountedPrice)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "FF6B35"))
                +
                Text(" \(originalPrice)")
                    .font(.subheadline)
                    .strikethrough()
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text("📍 \(distance) • \(expiry)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {}) {
                    Text("View Deal")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "FF6B35"))
                        .cornerRadius(16)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
}
