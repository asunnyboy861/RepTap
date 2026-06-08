import SwiftUI

struct WorkoutCompleteView: View {
    @Environment(\.dismiss) private var dismiss
    let volume: Double
    let duration: String
    let score: Int
    let isPro: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Color.appGreen)

                Text("Workout Complete!")
                    .font(.title.bold())

                HStack(spacing: 24) {
                    StatItem(title: "Volume", value: volume.formattedVolume)
                    StatItem(title: "Duration", value: duration)
                    if isPro {
                        StatItem(title: "Score", value: "\(score)")
                    }
                }

                if isPro && score >= 80 {
                    Text("Outstanding workout! You crushed it!")
                        .font(.subheadline)
                        .foregroundStyle(Color.appOrange)
                }

                Button("Done") {
                    dismiss()
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.appOrange, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(Color.appOrange)
            Text(title)
                .font(.caption)
                .foregroundStyle(Color.appTextSecondary)
        }
    }
}
