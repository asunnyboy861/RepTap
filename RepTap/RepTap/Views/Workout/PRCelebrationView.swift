import SwiftUI

struct PRCelebrationView: View {
    let pr: PersonalRecord
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("🏆")
                .font(.system(size: 64))

            Text("New PR!")
                .font(.title.bold())

            Text(pr.exerciseName)
                .font(.headline)

            Text(pr.recordType)
                .font(.subheadline)
                .foregroundStyle(Color.appTextSecondary)

            Text(pr.value.formattedWeight)
                .font(.title2.bold())
                .foregroundStyle(Color.appOrange)

            Button("Awesome!") {
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
