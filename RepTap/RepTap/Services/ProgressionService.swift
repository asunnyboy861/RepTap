import Foundation
import SwiftData

struct ProgressionService {
    struct Suggestion {
        let weight: Double
        let reps: Int
        let confidence: Confidence
        let reasoning: String
    }

    enum Confidence: String {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }

    static func suggestProgression(exerciseName: String, currentWeight: Double, currentReps: Int, modelContext: ModelContext) -> Suggestion? {
        let fourWeeksAgo = Calendar.current.date(byAdding: .weekOfYear, value: -4, to: .now)!
        let descriptor = FetchDescriptor<ExerciseSet>(
            predicate: #Predicate { $0.isCompleted && $0.loggedAt >= fourWeeksAgo }
        )
        guard let allSets = try? modelContext.fetch(descriptor) else { return nil }

        let exerciseSets = allSets.filter { $0.workoutExercise?.exercise?.name == exerciseName }
        guard !exerciseSets.isEmpty else { return nil }

        let avgReps = Double(exerciseSets.map(\.reps).reduce(0, +)) / Double(exerciseSets.count)
        let completionRate = Double(exerciseSets.filter { $0.reps >= currentReps }.count) / Double(exerciseSets.count)

        let confidence: Confidence
        if exerciseSets.count >= 8 {
            confidence = .high
        } else if exerciseSets.count >= 4 {
            confidence = .medium
        } else {
            confidence = .low
        }

        if completionRate >= 0.8 && avgReps >= Double(currentReps) {
            let suggestedWeight = currentWeight + 5
            let suggestedReps = max(currentReps - 1, 1)
            return Suggestion(weight: suggestedWeight, reps: suggestedReps, confidence: confidence, reasoning: "You completed \(Int(completionRate * 100))% of sets at this level. Try increasing weight.")
        } else if completionRate >= 0.6 {
            let suggestedReps = currentReps + 1
            return Suggestion(weight: currentWeight, reps: suggestedReps, confidence: confidence, reasoning: "Good progress! Try adding a rep before increasing weight.")
        } else {
            let suggestedWeight = currentWeight - 5
            return Suggestion(weight: max(suggestedWeight, 0), reps: currentReps, confidence: confidence, reasoning: "Completion rate is \(Int(completionRate * 100))%. Consider deloading to build back up.")
        }
    }
}
