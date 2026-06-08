import Foundation
import SwiftData

@Model
final class ExerciseSet {
    var weight: Double
    var reps: Int
    var isCompleted: Bool
    var setNumber: Int
    var loggedAt: Date
    var workoutExercise: WorkoutExercise?

    init(weight: Double = 0, reps: Int = 0, setNumber: Int = 1) {
        self.weight = weight
        self.reps = reps
        self.isCompleted = false
        self.setNumber = setNumber
        self.loggedAt = .now
    }

    var volume: Double {
        isCompleted ? weight * Double(reps) : 0
    }

    var epley1RM: Double {
        guard reps > 1 else { return weight }
        return weight * (1 + Double(reps) / 30.0)
    }
}
