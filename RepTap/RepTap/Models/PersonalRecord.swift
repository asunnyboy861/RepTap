import Foundation
import SwiftData

@Model
final class PersonalRecord {
    var exerciseName: String
    var recordType: String
    var value: Double
    var secondaryValue: Double
    var achievedDate: Date
    var weight: Double
    var reps: Int

    init(exerciseName: String, recordType: String, value: Double, secondaryValue: Double = 0, weight: Double = 0, reps: Int = 0) {
        self.exerciseName = exerciseName
        self.recordType = recordType
        self.value = value
        self.secondaryValue = secondaryValue
        self.achievedDate = .now
        self.weight = weight
        self.reps = reps
    }
}

enum PRType: String, CaseIterable {
    case oneRM = "1RM"
    case threeRM = "3RM"
    case fiveRM = "5RM"
    case tenRM = "10RM"
    case maxWeight = "Max Weight"
    case maxVolume = "Max Volume"
}
