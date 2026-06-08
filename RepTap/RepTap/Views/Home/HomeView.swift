import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var workoutVM = WorkoutViewModel()
    @State private var settingsVM = SettingsViewModel()
    @State private var showActiveWorkout = false
    @Query(filter: #Predicate<Workout> { $0.isComplete }, sort: \Workout.startDate, order: .reverse)
    private var recentWorkouts: [Workout]
    @Query(sort: \WorkoutTemplate.lastUsedAt, order: .reverse)
    private var templates: [WorkoutTemplate]

    init() {}

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    startWorkoutButton
                    streakCard
                    recentRoutinesSection
                    recentWorkoutsSection
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("RepTap")
            .sheet(isPresented: $showActiveWorkout) {
                if workoutVM.activeWorkout != nil {
                    ActiveWorkoutView(viewModel: workoutVM, settingsVM: settingsVM)
                }
            }
        }
    }

    private var startWorkoutButton: some View {
        Button {
            workoutVM.startWorkout(modelContext: modelContext)
            showActiveWorkout = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                Text("Start Workout")
                    .font(.title3.bold())
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.appOrange, in: RoundedRectangle(cornerRadius: 14))
        }
    }

    private var streakCard: some View {
        HStack(spacing: 16) {
            Image(systemName: "flame.fill")
                .font(.title)
                .foregroundStyle(Color.appOrange)
            VStack(alignment: .leading) {
                Text("This Week")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                Text("\(uniqueTrainingDays) days")
                    .font(.title2.bold())
            }
            Spacer()
            if !recentWorkouts.isEmpty {
                VStack(alignment: .trailing) {
                    Text("Last Workout")
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                    Text(recentWorkouts.first?.startDate.formattedDateOnly ?? "")
                        .font(.subheadline.bold())
                }
            }
        }
        .padding()
        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 12))
    }

    private var recentRoutinesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Start")
                .font(.headline)
            if templates.isEmpty {
                Text("No routines yet. Create one in the Routines tab.")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(templates.prefix(5)) { template in
                            Button {
                                workoutVM.startWorkoutFromTemplate(template, modelContext: modelContext)
                                showActiveWorkout = true
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(template.name)
                                        .font(.subheadline.bold())
                                        .lineLimit(1)
                                    Text("\(template.exercises.count) exercises")
                                        .font(.caption)
                                        .foregroundStyle(Color.appTextSecondary)
                                }
                                .padding(12)
                                .frame(width: 140, alignment: .leading)
                                .background(Color.appCard, in: RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    private var recentWorkoutsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Workouts")
                .font(.headline)
            if recentWorkouts.isEmpty {
                Text("No workouts yet. Tap Start Workout to begin!")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
            } else {
                ForEach(recentWorkouts.prefix(5)) { workout in
                    NavigationLink(value: workout) {
                        WorkoutRowView(workout: workout)
                    }
                }
            }
        }
    }

    private var uniqueTrainingDays: Int {
        let calendar = Calendar.current
        let now = Date.now
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let thisWeekWorkouts = recentWorkouts.filter { $0.startDate >= startOfWeek }
        let uniqueDays = Set(thisWeekWorkouts.map { calendar.component(.weekday, from: $0.startDate) })
        return uniqueDays.count
    }
}

struct WorkoutRowView: View {
    let workout: Workout

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.subheadline.bold())
                Text(workout.startDate.formattedDateOnly)
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(workout.totalVolume.formattedVolume + " vol")
                    .font(.subheadline.bold())
                    .foregroundStyle(Color.appOrange)
                Text(workout.formattedDuration)
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .padding(12)
        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 10))
    }
}
