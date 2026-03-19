import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Promoted Section
                    VStack(alignment: .leading) {
                        Text("🔥 Promoted")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        PromotedDealCard()
                    }
                    
                    // Friends Activity
                    VStack(alignment: .leading) {
                        Text("👥 Friends Activity")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        VStack(spacing: 0) {
                            ActivityRow(name: "Alex", action: "claimed 🍔 Burger Deal", initial: "A")
                            Divider()
                            ActivityRow(name: "Sarah", action: "joined a Study Session", initial: "S")
                            Divider()
                            ActivityRow(name: "Mike", action: "found 🎬 Cinema Deal", initial: "M")
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
                        
                        DealCard(
                            title: "🎬 Cinema Ticket",
                            originalPrice: "$100",
                            discountedPrice: "$65",
                            discount: "-35%",
                            distance: "0.8km",
                            expiry: "Expires in 3 days"
                        )
                        
                        DealCard(
                            title: "☕ Coffee 20% Off",
                            originalPrice: "$20",
                            discountedPrice: "$16",
                            discount: "-20%",
                            distance: "0.5km",
                            expiry: "Valid until weekend"
                        )
                    }
                }
                .padding()
            }
            .background(Color(hex: "F7F7F7"))
            .navigationTitle("🐻 DealBuddy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        Image(systemName: "bell")
                        Image(systemName: "person.circle")
                    }
                }
            }
        }
    }
}

struct PromotedDealCard: View {
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
                
                Text("$6.99")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "FFD700"))
                +
                Text(" $12")
                    .font(.body)
                    .strikethrough()
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text("🍔 50% Off Burger Set")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Just 0.3km away! Limited time")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
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
