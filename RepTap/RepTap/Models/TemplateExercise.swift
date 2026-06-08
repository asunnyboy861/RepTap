import Foundation
import SwiftData

@Model
final class TemplateExercise {
    var exercise: Exercise?
    var targetSets: Int
    var targetReps: Int
    var sortOrder: Int
    var template: WorkoutTemplate?

    init(targetSets: Int = 3, targetReps: Int = 10, sortOrder: Int = 0) {
        self.targetSets = targetSets
        self.targetReps = targetReps
        self.sortOrder = sortOrder
    }
}
