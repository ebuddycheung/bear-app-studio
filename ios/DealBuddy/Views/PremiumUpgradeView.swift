import SwiftUI
import StoreKit

struct PremiumUpgradeView: View {
    @StateObject private var iapService = IAPService.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "star.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.white)
                        }
                        
                        Text("Upgrade to Premium")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Unlock all features and save money!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 24)
                    
                    // Features List
                    VStack(alignment: .leading, spacing: 16) {
                        Text("✨ Premium Features")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(PremiumFeature.allCases, id: \.self) { feature in
                            HStack(spacing: 12) {
                                Image(systemName: feature.icon)
                                    .font(.title2)
                                    .foregroundColor(Color(hex: "FFD700"))
                                    .frame(width: 32)
                                
                                Text(feature.rawValue)
                                    .font(.body)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Pricing Options
                    VStack(spacing: 12) {
                        Text("📱 Choose Your Plan")
                            .font(.headline)
                        
                        ForEach(iapService.products, id: \.id) { product in
                            PricingCard(product: product) {
                                Task {
                                    let success = await iapService.purchase(product)
                                    if success {
                                        showSuccessAlert = true
                                    }
                                }
                            }
                        }
                        
                        if iapService.products.isEmpty && !iapService.isLoading {
                            Text("Loading plans...")
                                .foregroundColor(.gray)
                        }
                        
                        // Restore purchases
                        Button("Restore Purchases") {
                            Task {
                                await iapService.restorePurchases()
                            }
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    // Error message
                    if let error = iapService.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    // Monthly savings note
                    VStack(spacing: 4) {
                        Text("🔒 Secure payment via Apple")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("Cancel anytime in Settings")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 8)
                }
            }
            .background(Color(hex: "F7F7F7"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("🎉 Premium Activated!", isPresented: $showSuccessAlert) {
                Button("Awesome!") {
                    dismiss()
                }
            } message: {
                Text("Welcome to DealBuddy Premium! You now have access to all premium features.")
            }
            .task {
                await iapService.fetchProducts()
            }
        }
    }
}

struct PricingCard: View {
    let product: Product
    let onPurchase: () -> Void
    @StateObject private var iapService = IAPService.shared
    
    private var isYearly: Bool {
        product.id == ProductIdentifier.yearly.rawValue
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if isYearly {
                HStack {
                    Spacer()
                    Text("BEST VALUE")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "FF6B35"))
                        .cornerRadius(8)
                }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(isYearly ? "Premium Yearly" : "Premium Monthly")
                        .font(.headline)
                    
                    if isYearly {
                        Text("Best value!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: onPurchase) {
                    HStack(spacing: 4) {
                        Text(product.price.description)
                            .fontWeight(.bold)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(isYearly ? Color(hex: "FF6B35") : Color(hex: "004E89"))
                    .cornerRadius(20)
                }
                .disabled(iapService.isLoading)
            }
            
            if isYearly, let savings = ProductIdentifier.yearly.savings {
                Text(savings)
                    .font(.caption)
                    .foregroundColor(Color(hex: "FF6B35"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isYearly ? Color(hex: "FF6B35") : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    PremiumUpgradeView()
}
