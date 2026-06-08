import Foundation
import SwiftData
import Observation

@MainActor @Observable
class WorkoutViewModel {
    var activeWorkout: Workout?
    var restTimerSeconds: Int = 0
    var isRestTimerRunning = false
    var showPRCelebration = false
    var newPR: PersonalRecord?
    var progressionSuggestion: ProgressionService.Suggestion?

    private var restTimer: Timer?
    private let healthKitService = HealthKitService()

    var defaultRestSeconds: Int {
        UserDefaults.standard.integer(forKey: "defaultRestSeconds").nonZeroOr(90)
    }

    func startWorkout(name: String = "", modelContext: ModelContext) {
        let workout = Workout(name: name.isEmpty ? "Workout" : name)
        modelContext.insert(workout)
        activeWorkout = workout
    }

    func startWorkoutFromTemplate(_ template: WorkoutTemplate, modelContext: ModelContext) {
        let workout = Workout(name: template.name)
        modelContext.insert(workout)
        for (index, te) in template.exercises.sorted(by: { $0.sortOrder < $1.sortOrder }).enumerated() {
            let we = WorkoutExercise(sortOrder: index, restSeconds: te.exercise?.defaultRestSeconds ?? defaultRestSeconds)
            we.exercise = te.exercise
            we.workout = workout
            for setNum in 1...te.targetSets {
                let set = ExerciseSet(setNumber: setNum)
                set.workoutExercise = we
                we.sets.append(set)
            }
            workout.exercises.append(we)
        }
        template.lastUsedAt = .now
        activeWorkout = workout
    }

    func addExercise(_ exercise: Exercise, modelContext: ModelContext) {
        guard let workout = activeWorkout else { return }
        let we = WorkoutExercise(sortOrder: workout.exercises.count, restSeconds: exercise.defaultRestSeconds)
        we.exercise = exercise
        we.workout = workout
        let set = ExerciseSet(setNumber: 1)
        set.workoutExercise = we
        we.sets.append(set)
        workout.exercises.append(we)
    }

    func logSet(workoutExercise: WorkoutExercise, weight: Double, reps: Int, modelContext: ModelContext, isPro: Bool) {
        guard let set = workoutExercise.sets.first(where: { !$0.isCompleted }) else { return }
        set.weight = weight
        set.reps = reps
        set.isCompleted = true
        set.loggedAt = .now

        HapticService.logSet()

        if let nextSetNumber = workoutExercise.sets.last?.setNumber,
           workoutExercise.sets.filter({ $0.isCompleted }).count == workoutExercise.sets.count {
            let newSet = ExerciseSet(setNumber: nextSetNumber + 1)
            newSet.workoutExercise = workoutExercise
            workoutExercise.sets.append(newSet)
        }

        if let exerciseName = workoutExercise.exercise?.name {
            let pr = PRDetectionService.checkForPR(
                exerciseName: exerciseName,
                weight: weight,
                reps: reps,
                modelContext: modelContext
            )
            if let pr = pr {
                newPR = pr
                showPRCelebration = true
                HapticService.prCelebration()
            }

            if isPro {
                progressionSuggestion = ProgressionService.suggestProgression(
                    exerciseName: exerciseName,
                    currentWeight: weight,
                    currentReps: reps,
                    modelContext: modelContext
                )
            }
        }

        startRestTimer(seconds: workoutExercise.restSeconds)
        updateWorkoutVolume()
    }

    func addSet(to workoutExercise: WorkoutExercise) {
        let nextNumber = (workoutExercise.sets.map(\.setNumber).max() ?? 0) + 1
        let set = ExerciseSet(setNumber: nextNumber)
        set.workoutExercise = workoutExercise
        workoutExercise.sets.append(set)
    }

    func removeSet(_ set: ExerciseSet, from workoutExercise: WorkoutExercise) {
        workoutExercise.sets.removeAll { $0 === set }
        for (index, s) in workoutExercise.sets.enumerated() {
            s.setNumber = index + 1
        }
    }

    func completeWorkout(modelContext: ModelContext) async {
        guard let workout = activeWorkout else { return }
        workout.endDate = .now
        workout.isComplete = true
        workout.duration = workout.endDate!.timeIntervalSince(workout.startDate)

        await healthKitService.saveWorkout(
            startDate: workout.startDate,
            endDate: workout.endDate!,
            totalVolume: workout.totalVolume,
            exercises: workout.exercises
        )

        activeWorkout = nil
        stopRestTimer()
    }

    func cancelWorkout(modelContext: ModelContext) {
        if let workout = activeWorkout {
            modelContext.delete(workout)
        }
        activeWorkout = nil
        stopRestTimer()
    }

    func getLastSetValues(for exercise: Exercise, modelContext: ModelContext) -> (weight: Double, reps: Int) {
        let descriptor = FetchDescriptor<ExerciseSet>(
            predicate: #Predicate { $0.isCompleted },
            sortBy: [SortDescriptor(\.loggedAt, order: .reverse)]
        )
        guard let allSets = try? modelContext.fetch(descriptor) else { return (0, 0) }
        let matching = allSets.filter { $0.workoutExercise?.exercise?.name == exercise.name }
        guard let last = matching.first else { return (0, 0) }
        return (last.weight, last.reps)
    }

    private func startRestTimer(seconds: Int) {
        stopRestTimer()
        restTimerSeconds = seconds
        isRestTimerRunning = true
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                if self.restTimerSeconds > 0 {
                    self.restTimerSeconds -= 1
                } else {
                    self.isRestTimerRunning = false
                    self.restTimer?.invalidate()
                    HapticService.restComplete()
                }
            }
        }
    }

    func stopRestTimer() {
        restTimer?.invalidate()
        restTimer = nil
        isRestTimerRunning = false
        restTimerSeconds = 0
    }

    func skipRest() {
        stopRestTimer()
    }

    private func updateWorkoutVolume() {
        guard let workout = activeWorkout else { return }
        workout.totalVolume = workout.exercises.reduce(0) { $0 + $1.totalVolume }
    }
}

extension Int {
    func nonZeroOr(_ default: Int) -> Int {
        self == 0 ? `default` : self
    }
}
