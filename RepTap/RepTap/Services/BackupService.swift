import Foundation
import SwiftData

struct BackupService {
    static func exportCSV(modelContext: ModelContext) -> String? {
        let descriptor = FetchDescriptor<Workout>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        guard let workouts = try? modelContext.fetch(descriptor) else { return nil }

        var csv = "Date,Exercise,Set,Weight(lbs),Reps,Volume\n"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        for workout in workouts {
            let dateStr = formatter.string(from: workout.startDate)
            for we in workout.exercises {
                let exerciseName = we.exercise?.name ?? "Unknown"
                for set in we.sets where set.isCompleted {
                    csv += "\(dateStr),\(exerciseName),\(set.setNumber),\(set.weight),\(set.reps),\(set.volume)\n"
                }
            }
        }
        return csv
    }

    static func exportJSON(modelContext: ModelContext) -> Data? {
        let descriptor = FetchDescriptor<Workout>(sortBy: [SortDescriptor(\.startDate, order: .reverse)])
        guard let workouts = try? modelContext.fetch(descriptor) else { return nil }

        var result: [[String: Any]] = []
        for workout in workouts {
            var workoutDict: [String: Any] = [
                "startDate": workout.startDate.ISO8601Format(),
                "endDate": workout.endDate?.ISO8601Format() ?? "",
                "totalVolume": workout.totalVolume,
                "exercises": []
            ]
            var exercisesArr: [[String: Any]] = []
            for we in workout.exercises {
                var exerciseDict: [String: Any] = [
                    "name": we.exercise?.name ?? "Unknown",
                    "sets": []
                ]
                var setsArr: [[String: Any]] = []
                for set in we.sets where set.isCompleted {
                    setsArr.append([
                        "setNumber": set.setNumber,
                        "weight": set.weight,
                        "reps": set.reps,
                        "volume": set.volume
                    ])
                }
                exerciseDict["sets"] = setsArr
                exercisesArr.append(exerciseDict)
            }
            workoutDict["exercises"] = exercisesArr
            result.append(workoutDict)
        }
        return try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
    }
}
