import Foundation
import SwiftData

struct PRDetectionService {
    static func checkForPR(exerciseName: String, weight: Double, reps: Int, modelContext: ModelContext) -> PersonalRecord? {
        let epley1RM = reps > 1 ? weight * (1 + Double(reps) / 30.0) : weight
        var newPR: PersonalRecord?

        let descriptor = FetchDescriptor<PersonalRecord>(
            predicate: #Predicate { $0.exerciseName == exerciseName }
        )
        let existingPRs = (try? modelContext.fetch(descriptor)) ?? []

        let prChecks: [(PRType, Double)] = [
            (.oneRM, epley1RM),
            (.maxWeight, weight),
            (.maxVolume, weight * Double(reps))
        ]

        if reps <= 3 {
            if let existing = existingPRs.first(where: { $0.recordType == PRType.threeRM.rawValue }) {
                if epley1RM > existing.value {
                    existing.value = epley1RM
                    existing.weight = weight
                    existing.reps = reps
                    existing.achievedDate = .now
                    newPR = existing
                }
            } else {
                let pr = PersonalRecord(exerciseName: exerciseName, recordType: PRType.threeRM.rawValue, value: epley1RM, weight: weight, reps: reps)
                modelContext.insert(pr)
                newPR = pr
            }
        }

        if reps <= 5 {
            if let existing = existingPRs.first(where: { $0.recordType == PRType.fiveRM.rawValue }) {
                if epley1RM > existing.value {
                    existing.value = epley1RM
                    existing.weight = weight
                    existing.reps = reps
                    existing.achievedDate = .now
                    newPR = existing
                }
            } else {
                let pr = PersonalRecord(exerciseName: exerciseName, recordType: PRType.fiveRM.rawValue, value: epley1RM, weight: weight, reps: reps)
                modelContext.insert(pr)
                newPR = pr
            }
        }

        if reps <= 10 {
            if let existing = existingPRs.first(where: { $0.recordType == PRType.tenRM.rawValue }) {
                if epley1RM > existing.value {
                    existing.value = epley1RM
                    existing.weight = weight
                    existing.reps = reps
                    existing.achievedDate = .now
                    newPR = existing
                }
            } else {
                let pr = PersonalRecord(exerciseName: exerciseName, recordType: PRType.tenRM.rawValue, value: epley1RM, weight: weight, reps: reps)
                modelContext.insert(pr)
                newPR = pr
            }
        }

        for (prType, value) in prChecks {
            if let existing = existingPRs.first(where: { $0.recordType == prType.rawValue }) {
                if value > existing.value {
                    existing.value = value
                    existing.weight = weight
                    existing.reps = reps
                    existing.achievedDate = .now
                    newPR = existing
                }
            } else {
                let pr = PersonalRecord(exerciseName: exerciseName, recordType: prType.rawValue, value: value, weight: weight, reps: reps)
                modelContext.insert(pr)
                newPR = pr
            }
        }

        return newPR
    }
}
