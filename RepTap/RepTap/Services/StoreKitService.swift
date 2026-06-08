import Foundation
import StoreKit

@MainActor
@Observable
class StoreKitService {
    var isPro: Bool = false
    var product: Product?
    var isLoading = false

    private let productID = "com.zzoutuo.RepTap.pro"

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [productID])
            product = products.first
        } catch {
            print("StoreKit load product error: \(error)")
        }
    }

    func purchase() async -> Bool {
        guard let product = product else { return false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    isPro = true
                    await transaction.finish()
                    return true
                }
            case .pending, .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            print("StoreKit purchase error: \(error)")
        }
        return false
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
        } catch {
            print("StoreKit restore error: \(error)")
        }
        checkProStatus()
    }

    func checkProStatus() {
        Task {
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    if transaction.productID == productID {
                        isPro = transaction.revocationDate == nil
                        return
                    }
                }
            }
            isPro = false
        }
    }
}
