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
    
    // MARK: - Fetch Products
    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let productIds = ProductIdentifier.allCases.map { $0.rawValue }
            let request = SKProductsRequest(productIdentifiers: Set(productIds))
            let response = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<SKProductsResponse, Error>) in
                request.delegate = ProductsRequestDelegate(continuation: continuation)
                request.start()
            }
            
            products = response.products.sorted { $0.price.doubleValue < $1.price.doubleValue }
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
                await updatePurchasedIds()
                await transaction.finish()
                isLoading = false
                return true
                
            case .userCancelled:
                isLoading = false
                return false
                
            case .pending:
                isLoading = false
                errorMessage = "Purchase is pending approval"
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
        
        do {
            try await AppStore.sync()
            await updatePurchasedIds()
        } catch {
            errorMessage = "Failed to restore: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Check Premium Status
    var isPremium: Bool {
        !purchasedProductIds.isEmpty
    }
    
    // MARK: - Private Helpers
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updatePurchasedIds()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    private func updatePurchasedIds() async {
        var ids = Set<String>()
        
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                ids.insert(transaction.productID)
            }
        }
        
        await MainActor.run {
            self.purchasedProductIds = ids
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw IAPError.verificationFailed
        case .verified(let signedType):
            return signedType
        }
    }
}

// MARK: - IAP Error
enum IAPError: LocalizedError {
    case verificationFailed
    case purchaseFailed
    
    var errorDescription: String? {
        switch self {
        case .verificationFailed: return "Purchase verification failed"
        case .purchaseFailed: return "Purchase failed"
        }
    }
}

// MARK: - Products Request Delegate
private class ProductsRequestDelegate: NSObject, SKProductsRequestDelegate {
    private let continuation: CheckedContinuation<SKProductsResponse, Error>
    
    init(continuation: CheckedContinuation<SKProductsResponse, Error>) {
        self.continuation = continuation
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        continuation.resume(returning: response)
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        continuation.resume(throwing: error)
    }
}

// MARK: - Product Extension
extension Product {
    var priceString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceFormatLocale
        return formatter.string(from: price) ?? "\(price)"
    }
    
    var periodString: String? {
        switch productIdentifier {
        case ProductIdentifier.monthly.rawValue:
            return "per month"
        case ProductIdentifier.yearly.rawValue:
            return "per year"
        default:
            return nil
        }
    }
}
