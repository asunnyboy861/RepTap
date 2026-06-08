import Foundation
import SwiftData

@Model
final class WorkoutExercise {
    var exercise: Exercise?
    var sortOrder: Int
    var restSeconds: Int
    @Relationship(deleteRule: .cascade)
    var sets: [ExerciseSet] = []
    var workout: Workout?

    init(sortOrder: Int = 0, restSeconds: Int = 90) {
        self.sortOrder = sortOrder
        self.restSeconds = restSeconds
    }

    var totalVolume: Double {
        sets.filter { $0.isCompleted }.reduce(0) { $0 + $1.volume }
    }

    var completedSetCount: Int {
        sets.filter { $0.isCompleted }.count
    }
}
