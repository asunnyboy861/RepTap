import Foundation
import SwiftData

@Model
final class Workout {
    var startDate: Date
    var endDate: Date?
    var name: String
    var totalVolume: Double
    var duration: TimeInterval
    var isComplete: Bool
    @Relationship(deleteRule: .cascade)
    var exercises: [WorkoutExercise] = []

    init(name: String = "", startDate: Date = .now) {
        self.name = name
        self.startDate = startDate
        self.endDate = nil
        self.totalVolume = 0
        self.duration = 0
        self.isComplete = false
    }

    var formattedDuration: String {
        let interval = endDate?.timeIntervalSince(startDate) ?? Date.now.timeIntervalSince(startDate)
        let hours = Int(interval) / 3600
        let minutes = Int(interval) % 3600 / 60
        let seconds = Int(interval) % 60
        if hours > 0 {
            return String(format: "%dh %dm", hours, minutes)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }
}
