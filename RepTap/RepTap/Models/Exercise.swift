import Foundation
import SwiftData

@Model
final class Exercise {
    var name: String
    var muscleGroup: String
    var equipment: String
    var isCustom: Bool
    var defaultRestSeconds: Int
    @Relationship(deleteRule: .cascade, inverse: \WorkoutExercise.exercise)
    var workoutExercises: [WorkoutExercise] = []
    @Relationship(deleteRule: .cascade, inverse: \TemplateExercise.exercise)
    var templateExercises: [TemplateExercise] = []

    init(name: String, muscleGroup: String, equipment: String = "", isCustom: Bool = false, defaultRestSeconds: Int = 90) {
        self.name = name
        self.muscleGroup = muscleGroup
        self.equipment = equipment
        self.isCustom = isCustom
        self.defaultRestSeconds = defaultRestSeconds
    }
}

enum MuscleGroup: String, CaseIterable, Codable {
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case legs = "Legs"
    case core = "Core"
    case cardio = "Cardio"
}
