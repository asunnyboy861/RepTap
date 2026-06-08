import SwiftUI
import SwiftData

struct ActiveWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: WorkoutViewModel
    @Bindable var settingsVM: SettingsViewModel
    @State private var showExercisePicker = false
    @State private var showWorkoutComplete = false
    @State private var showProPaywall = false
    @State private var workoutScore = 0
    @State private var storeKitService = StoreKitService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isRestTimerRunning {
                    RestTimerView(seconds: viewModel.restTimerSeconds, skipAction: { viewModel.skipRest() })
                }

                ScrollView {
                    VStack(spacing: 16) {
                        workoutHeader
                        exercisesList
                        addExerciseButton
                    }
                    .padding()
                }

                if let workout = viewModel.activeWorkout {
                    Button {
                        Task {
                            workoutScore = ProgressViewModel().calculateWorkoutScore(workout, modelContext: modelContext)
                            await viewModel.completeWorkout(modelContext: modelContext)
                            showWorkoutComplete = true
                        }
                    } label: {
                        Text("Finish Workout")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.appOrange, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.cancelWorkout(modelContext: modelContext)
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
            }
            .sheet(isPresented: $showExercisePicker) {
                ExercisePickerView { exercise in
                    viewModel.addExercise(exercise, modelContext: modelContext)
                }
            }
            .sheet(isPresented: $showWorkoutComplete) {
                WorkoutCompleteView(volume: viewModel.activeWorkout?.totalVolume ?? 0, duration: viewModel.activeWorkout?.formattedDuration ?? "0:00", score: workoutScore, isPro: storeKitService.isPro)
            }
            .sheet(isPresented: $showProPaywall) {
                ProPurchaseView(storeKitService: storeKitService)
            }
        }
    }

    private var workoutHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.activeWorkout?.name ?? "Workout")
                    .font(.headline)
                Text(viewModel.activeWorkout?.startDate.formattedShort ?? "")
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(viewModel.activeWorkout?.totalVolume.formattedVolume ?? "0")
                    .font(.title3.bold())
                    .foregroundStyle(Color.appOrange)
                Text("volume")
                    .font(.caption2)
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .padding()
        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 12))
    }

    private var exercisesList: some View {
        VStack(spacing: 12) {
            if let workout = viewModel.activeWorkout {
                ForEach(workout.exercises.sorted(by: { $0.sortOrder < $1.sortOrder })) { workoutExercise in
                    ExerciseSectionView(
                        workoutExercise: workoutExercise,
                        viewModel: viewModel,
                        isPro: storeKitService.isPro,
                        onProTap: { showProPaywall = true }
                    )
                }
            }
        }
    }

    private var addExerciseButton: some View {
        Button {
            showExercisePicker = true
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                Text("Add Exercise")
            }
            .font(.subheadline.bold())
            .foregroundStyle(Color.appOrange)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.appCard, in: RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct ExerciseSectionView: View {
    let workoutExercise: WorkoutExercise
    @Bindable var viewModel: WorkoutViewModel
    let isPro: Bool
    let onProTap: () -> Void
    @State private var currentWeight: Double = 0
    @State private var currentReps: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(workoutExercise.exercise?.name ?? "Exercise")
                    .font(.subheadline.bold())
                Spacer()
                Text(workoutExercise.exercise?.muscleGroup ?? "")
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.appOrange.opacity(0.15), in: Capsule())
            }

            ForEach(workoutExercise.sets) { set in
                SetRowView(
                    set: set,
                    weight: set.isCompleted ? set.weight : currentWeight,
                    reps: set.isCompleted ? set.reps : currentReps,
                    isPro: isPro,
                    onLog: {
                        viewModel.logSet(
                            workoutExercise: workoutExercise,
                            weight: currentWeight,
                            reps: currentReps,
                            modelContext: modelContext,
                            isPro: isPro
                        )
                        if let exercise = workoutExercise.exercise {
                            let last = viewModel.getLastSetValues(for: exercise, modelContext: modelContext)
                            currentWeight = last.weight
                            currentReps = last.reps
                        }
                    },
                    onProTap: onProTap
                )
            }

            if let lastSet = workoutExercise.sets.last, lastSet.isCompleted {
                Button {
                    viewModel.addSet(to: workoutExercise)
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Set")
                    }
                    .font(.caption)
                    .foregroundStyle(Color.appOrange)
                }
            }

            if let suggestion = viewModel.progressionSuggestion,
               workoutExercise.exercise?.name == workoutExercise.sets.last?.workoutExercise?.exercise?.name {
                SuggestionBanner(suggestion: suggestion, isPro: isPro, onProTap: onProTap)
            }
        }
        .padding()
        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 12))
        .onAppear {
            if let exercise = workoutExercise.exercise {
                let last = viewModel.getLastSetValues(for: exercise, modelContext: modelContext)
                if currentWeight == 0 { currentWeight = last.weight }
                if currentReps == 0 { currentReps = last.reps }
            }
        }
    }

    @Environment(\.modelContext) private var modelContext
}

struct SetRowView: View {
    let set: ExerciseSet
    let weight: Double
    let reps: Int
    let isPro: Bool
    let onLog: () -> Void
    let onProTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text("\(set.setNumber)")
                .font(.caption.bold())
                .foregroundStyle(Color.appTextSecondary)
                .frame(width: 20)

            if set.isCompleted {
                Text("\(Int(set.weight)) x \(set.reps)")
                    .font(.subheadline)
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color.appGreen)
            } else {
                Text("\(Int(weight)) lbs x \(reps)")
                    .font(.subheadline)
                Spacer()
                Button("Done") {
                    onLog()
                }
                .font(.caption.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.appOrange, in: RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.vertical, 6)
    }
}

struct SuggestionBanner: View {
    let suggestion: ProgressionService.Suggestion
    let isPro: Bool
    let onProTap: () -> Void

    var body: some View {
        if isPro {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(Color.appProGold)
                Text("Try \(Int(suggestion.weight)) lbs x \(suggestion.reps)")
                    .font(.caption)
                Text("(\(suggestion.confidence.rawValue))")
                    .font(.caption2)
                    .foregroundStyle(Color.appTextSecondary)
            }
            .padding(8)
            .background(Color.appProGold.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
        } else {
            Button {
                onProTap()
            } label: {
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(Color.appProGold)
                    Text("Try \(Int(suggestion.weight)) lbs x \(suggestion.reps) — Unlock with Pro")
                        .font(.caption)
                }
                .padding(8)
                .background(Color.appProGold.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
