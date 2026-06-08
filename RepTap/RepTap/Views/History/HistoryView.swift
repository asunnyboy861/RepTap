import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Workout> { $0.isComplete }, sort: \Workout.startDate, order: .reverse)
    private var workouts: [Workout]
    @State private var searchText = ""

    var filteredWorkouts: [Workout] {
        if searchText.isEmpty { return workouts }
        return workouts.filter { workout in
            workout.name.localizedCaseInsensitiveContains(searchText) ||
            workout.exercises.contains { $0.exercise?.name.localizedCaseInsensitiveContains(searchText) == true }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredWorkouts) { workout in
                NavigationLink(value: workout) {
                    WorkoutRowView(workout: workout)
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Search workouts")
            .navigationTitle("History")
            .navigationDestination(for: Workout.self) { workout in
                WorkoutDetailView(workout: workout)
            }
        }
    }
}

struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                workoutSummary
                exercisesDetail
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationTitle(workout.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var workoutSummary: some View {
        HStack(spacing: 20) {
            StatItem(title: "Volume", value: workout.totalVolume.formattedVolume)
            StatItem(title: "Duration", value: workout.formattedDuration)
            StatItem(title: "Exercises", value: "\(workout.exercises.count)")
        }
        .padding()
        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 12))
    }

    private var exercisesDetail: some View {
        VStack(spacing: 12) {
            ForEach(workout.exercises.sorted(by: { $0.sortOrder < $1.sortOrder })) { we in
                VStack(alignment: .leading, spacing: 8) {
                    Text(we.exercise?.name ?? "Exercise")
                        .font(.subheadline.bold())

                    ForEach(we.sets.filter(\.isCompleted)) { set in
                        HStack {
                            Text("Set \(set.setNumber)")
                                .font(.caption)
                                .foregroundStyle(Color.appTextSecondary)
                                .frame(width: 50, alignment: .leading)
                            Text("\(Int(set.weight)) lbs x \(set.reps)")
                                .font(.caption)
                            Spacer()
                            Text("\(set.volume.formattedVolume) vol")
                                .font(.caption)
                                .foregroundStyle(Color.appTextSecondary)
                        }
                    }
                }
                .padding()
                .background(Color.appCard, in: RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}
