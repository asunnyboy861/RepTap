import SwiftUI
import StoreKit

struct ProPurchaseView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var storeKitService: StoreKitService

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Color.appProGold)

                Text("RepTap Pro")
                    .font(.title.bold())

                Text("One-time purchase. Forever yours.")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)

                VStack(alignment: .leading, spacing: 12) {
                    ProFeatureRow(icon: "lightbulb.fill", text: "Smart Progression Suggestions")
                    ProFeatureRow(icon: "chart.bar.fill", text: "Advanced Charts & Analysis")
                    ProFeatureRow(icon: "figure.strengthtraining.traditional", text: "Muscle Heatmap")
                    ProFeatureRow(icon: "star.fill", text: "Workout Score")
                    ProFeatureRow(icon: "ruler", text: "Body Measurements Tracking")
                    ProFeatureRow(icon: "lock.live", text: "Live Activity Rest Timer")
                    ProFeatureRow(icon: "arrow.up.doc", text: "Bulk Data Import")
                }
                .padding()
                .background(Color.appCard, in: RoundedRectangle(cornerRadius: 12))

                VStack(spacing: 8) {
                    Text("3-Year Cost Comparison")
                        .font(.caption.bold())
                    HStack(spacing: 16) {
                        ComparisonItem(name: "Fitbod", price: "$288")
                        ComparisonItem(name: "Strong", price: "$90")
                        ComparisonItem(name: "Hevy", price: "$72")
                        ComparisonItem(name: "RepTap", price: "$15", highlight: true)
                    }
                }

                if let product = storeKitService.product {
                    Button {
                        Task {
                            _ = await storeKitService.purchase()
                        }
                    } label: {
                        Text("Unlock Pro — \(product.displayPrice)")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.appOrange, in: RoundedRectangle(cornerRadius: 12))
                    }
                } else {
                    ProgressView()
                        .onAppear {
                            Task { await storeKitService.loadProduct() }
                        }
                }

                HStack(spacing: 16) {
                    Link("Privacy Policy", destination: URL(string: "https://asunnyboy861.github.io/RepTap/privacy.html")!)
                        .font(.caption2)
                        .foregroundStyle(Color.accentColor)
                    Link("Terms of Use", destination: URL(string: "https://asunnyboy861.github.io/RepTap/terms.html")!)
                        .font(.caption2)
                        .foregroundStyle(Color.accentColor)
                }
                .padding(.top, 4)
            }
            .padding()
            .background(Color.appBackground)
            .navigationTitle("Go Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

struct ProFeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(Color.appProGold)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
        }
    }
}

struct ComparisonItem: View {
    let name: String
    let price: String
    var highlight = false

    var body: some View {
        VStack(spacing: 2) {
            Text(name)
                .font(.caption2)
                .foregroundStyle(Color.appTextSecondary)
            Text(price)
                .font(.caption.bold())
                .foregroundStyle(highlight ? Color.appOrange : Color.appTextPrimary)
        }
    }
}
