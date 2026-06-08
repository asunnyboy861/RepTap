import Foundation
import SwiftData

@Model
final class WorkoutTemplate {
    var name: String
    var createdAt: Date
    var lastUsedAt: Date?
    @Relationship(deleteRule: .cascade)
    var exercises: [TemplateExercise] = []

    init(name: String) {
        self.name = name
        self.createdAt = .now
        self.lastUsedAt = nil
    }
}
