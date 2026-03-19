import Foundation
import StoreKit

// MARK: - Product Identifiers
enum ProductIdentifier: String, CaseIterable {
    case monthly = "com.dealbuddy.premium.monthly"
    case yearly = "com.dealbuddy.premium.yearly"
    
    var displayName: String {
        switch self {
        case .monthly: return "Premium Monthly"
        case .yearly: return "Premium Yearly"
        }
    }
    
    var price: String {
        switch self {
        case .monthly: return "$2.99/mo"
        case .yearly: return "$19.99/yr"
        }
    }
    
    var savings: String? {
        switch self {
        case .monthly: return nil
        case .yearly: return "Save 44%"
        }
    }
}

// MARK: - Premium Features
enum PremiumFeature: String, CaseIterable {
    case multiplePhotos = "Multiple Profile Photos"
    case customLinks = "Custom Social Links"
    case premiumBadge = "Premium Badge"
    case earlyAccess = "Early Access to Deals"
    case unlimitedFriends = "Unlimited Friends"
    
    var icon: String {
        switch self {
        case .multiplePhotos: return "photo.on.rectangle.angled"
        case .customLinks: return "link"
        case .premiumBadge: return "star.fill"
        case .earlyAccess: return "clock.badge.checkmark"
        case .unlimitedFriends: return "person.3.fill"
        }
    }
}

// MARK: - IAP Service
@MainActor
final class IAPService: ObservableObject {
    static let shared = IAPService()
    
    @Published var products: [Product] = []
    @Published var purchasedProductIds: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var listener: Task<Void, Error>?
    
    private init() {
        listener = listenForTransactions()
    }
    
    deinit {
        listener?.cancel()
    }
    
    // MARK: - Fetch Products (StoreKit 2)
    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let productIds = ProductIdentifier.allCases.map { $0.rawValue }
            let storeProducts = try await Product.products(for: productIds)
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Purchase
    func purchase(_ product: Product) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                purchasedProductIds.insert(product.id)
                isLoading = false
                return true
            case .userCancelled:
                isLoading = false
                return false
            case .pending:
                isLoading = false
                return false
            @unknown default:
                isLoading = false
                return false
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            isLoading = false
            return false
        }
    }
    
    // MARK: - Restore Purchases
    func restorePurchases() async {
        isLoading = true
        
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                purchasedProductIds.insert(transaction.productID)
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Check if Premium
    var isPremium: Bool {
        !purchasedProductIds.isEmpty
    }
    
    // MARK: - Listen for Transactions
    func listenForTransactions() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                await self.handleTransaction(result)
            }
        }
    }
    
    private func handleTransaction(_ result: VerificationResult<Transaction>) async {
        do {
            let transaction = try self.checkVerified(result)
            await transaction.finish()
            self.purchasedProductIds.insert(transaction.productID)
        } catch {
            print("Transaction verification failed: \(error)")
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreKitError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
}

// MARK: - StoreKit Errors
enum StoreKitError: Error {
    case verificationFailed
}
