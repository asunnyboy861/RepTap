import SwiftUI

struct RestTimerView: View {
    let seconds: Int
    let skipAction: () -> Void

    private var minutes: Int { seconds / 60 }
    private var remainingSeconds: Int { seconds % 60 }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "timer")
                .foregroundStyle(Color.appOrange)
            Text(String(format: "%d:%02d", minutes, remainingSeconds))
                .font(.title3.monospacedDigit().bold())
                .foregroundStyle(Color.appOrange)
            Spacer()
            Button("Skip") {
                skipAction()
            }
            .font(.subheadline.bold())
            .foregroundStyle(Color.appOrange)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.appOrange.opacity(0.1))
    }
}
