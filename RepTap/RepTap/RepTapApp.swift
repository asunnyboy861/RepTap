import SwiftUI
import SwiftData

@main
struct RepTapApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(for: [
            Workout.self,
            WorkoutExercise.self,
            ExerciseSet.self,
            Exercise.self,
            PersonalRecord.self,
            WorkoutTemplate.self,
            TemplateExercise.self,
            BodyMeasurement.self
        ])
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .tag(1)
            ProgressDashboardView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
                .tag(2)
            RoutinesView()
                .tabItem {
                    Label("Routines", systemImage: "list.bullet.clipboard")
                }
                .tag(3)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(Color.appOrange)
    }
}
