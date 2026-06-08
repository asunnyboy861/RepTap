import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentStep = 0
    @State private var selectedTrainingType = ""
    @State private var healthKitAuthorized = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        TabView(selection: $currentStep) {
            welcomeStep.tag(0)
            trainingTypeStep.tag(1)
            healthKitStep.tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }

    private var welcomeStep: some View {
        VStack(spacing: 32) {
            Spacer()
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.appOrange)

            Text("Welcome to RepTap")
                .font(.largeTitle.bold())

            Text("The honest workout tracker.\nLess UI, More Lifting.")
                .font(.body)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button("Get Started") {
                withAnimation { currentStep = 1 }
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.appOrange, in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .padding()
    }

    private var trainingTypeStep: some View {
        VStack(spacing: 24) {
            Text("What's your training style?")
                .font(.title2.bold())

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(["Bodybuilding", "Powerlifting", "CrossFit", "General Fitness", "Home Workout", "Sports"], id: \.self) { type in
                    Button {
                        selectedTrainingType = type
                        withAnimation { currentStep = 2 }
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: iconFor(type))
                                .font(.title2)
                                .foregroundStyle(Color.appOrange)
                            Text(type)
                                .font(.caption.bold())
                                .foregroundStyle(Color.appTextPrimary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }

    private var healthKitStep: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "heart.fill")
                .font(.system(size: 48))
                .foregroundStyle(.red)

            Text("Apple Health")
                .font(.title2.bold())

            Text("Sync your workouts to Apple Health for a complete fitness overview.")
                .font(.body)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)

            Button {
                Task {
                    let service = HealthKitService()
                    healthKitAuthorized = await service.requestAuthorization()
                    finishOnboarding()
                }
            } label: {
                Text("Enable HealthKit")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.appOrange, in: RoundedRectangle(cornerRadius: 12))
            }

            Button("Skip") {
                finishOnboarding()
            }
            .foregroundStyle(Color.appTextSecondary)

            Spacer()
        }
        .padding()
    }

    private func finishOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(selectedTrainingType, forKey: "trainingType")
    }

    private func iconFor(_ type: String) -> String {
        switch type {
        case "Bodybuilding": return "figure.bodybuilding"
        case "Powerlifting": return "figure.powerlifting"
        case "CrossFit": return "figure.crossfit"
        case "General Fitness": return "figure.run"
        case "Home Workout": return "house.fill"
        case "Sports": return "sportscourt.fill"
        default: return "figure.walk"
        }
    }
}
