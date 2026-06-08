import Foundation
import SwiftData
import Observation

@MainActor @Observable
class ExerciseViewModel {
    var searchText = ""
    var selectedMuscleGroup: MuscleGroup?
    var exercises: [Exercise] = []
    var filteredExercises: [Exercise] {
        var result = exercises
        if let group = selectedMuscleGroup {
            result = result.filter { $0.muscleGroup == group.rawValue }
        }
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return result
    }

    func loadExercises(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Exercise>(sortBy: [SortDescriptor(\.name)])
        exercises = (try? modelContext.fetch(descriptor)) ?? []

        if exercises.isEmpty {
            seedDatabase(modelContext: modelContext)
        }
    }

    func createCustomExercise(name: String, muscleGroup: String, equipment: String, modelContext: ModelContext) {
        let exercise = Exercise(name: name, muscleGroup: muscleGroup, equipment: equipment, isCustom: true)
        modelContext.insert(exercise)
        exercises.append(exercise)
    }

    private func seedDatabase(modelContext: ModelContext) {
        guard let url = Bundle.main.url(forResource: "ExerciseDatabase", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        guard let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: String]] else { return }

        for item in jsonArray {
            let exercise = Exercise(
                name: item["name"] ?? "",
                muscleGroup: item["muscleGroup"] ?? "",
                equipment: item["equipment"] ?? ""
            )
            modelContext.insert(exercise)
            exercises.append(exercise)
        }
    }
}
