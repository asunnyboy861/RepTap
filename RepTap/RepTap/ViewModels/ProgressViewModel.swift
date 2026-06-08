import Foundation
import SwiftData
import Observation
import Charts

@MainActor @Observable
class ProgressViewModel {
    var selectedTimeRange: TimeRange = .month
    var weeklyVolumeData: [WeeklyVolume] = []
    var personalRecords: [PersonalRecord] = []
    var recentWorkouts: [Workout] = []
    var weeklyStreak: Int = 0
    var muscleGroupDistribution: [MuscleGroupVolume] = []

    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case threeMonths = "3 Months"
        case year = "Year"
    }

    struct WeeklyVolume: Identifiable {
        let id = UUID()
        let weekStart: Date
        let totalVolume: Double
    }

    struct MuscleGroupVolume: Identifiable {
        let id = UUID()
        let muscleGroup: String
        let volume: Double
    }

    func loadData(modelContext: ModelContext) {
        loadWorkouts(modelContext: modelContext)
        loadPRs(modelContext: modelContext)
        calculateWeeklyStreak(modelContext: modelContext)
        calculateMuscleDistribution(modelContext: modelContext)
    }

    private func loadWorkouts(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<Workout>(
            predicate: #Predicate { $0.isComplete },
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        recentWorkouts = (try? modelContext.fetch(descriptor)) ?? []
        calculateWeeklyVolume()
    }

    private func loadPRs(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<PersonalRecord>(sortBy: [SortDescriptor(\.achievedDate, order: .reverse)])
        personalRecords = (try? modelContext.fetch(descriptor)) ?? []
    }

    private func calculateWeeklyVolume() {
        let calendar = Calendar.current
        var volumeMap: [Date: Double] = [:]

        for workout in recentWorkouts {
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: workout.startDate))!
            volumeMap[weekStart, default: 0] += workout.totalVolume
        }

        weeklyVolumeData = volumeMap.map { WeeklyVolume(weekStart: $0.key, totalVolume: $0.value) }
            .sorted { $0.weekStart < $1.weekStart }
    }

    private func calculateWeeklyStreak(modelContext: ModelContext) {
        let calendar = Calendar.current
        let now = Date.now
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!

        let descriptor = FetchDescriptor<Workout>(predicate: #Predicate { $0.isComplete && $0.startDate >= startOfWeek })
        let thisWeekWorkouts = (try? modelContext.fetch(descriptor)) ?? []
        let uniqueDays = Set(thisWeekWorkouts.map { calendar.component(.weekday, from: $0.startDate) })
        weeklyStreak = uniqueDays.count
    }

    private func calculateMuscleDistribution(modelContext: ModelContext) {
        let fourWeeksAgo = Calendar.current.date(byAdding: .weekOfYear, value: -4, to: .now)!
        let descriptor = FetchDescriptor<ExerciseSet>(
            predicate: #Predicate { $0.isCompleted && $0.loggedAt >= fourWeeksAgo }
        )
        guard let sets = try? modelContext.fetch(descriptor) else { return }

        var groupVolume: [String: Double] = [:]
        for set in sets {
            let group = set.workoutExercise?.exercise?.muscleGroup ?? "Other"
            groupVolume[group, default: 0] += set.volume
        }

        muscleGroupDistribution = groupVolume.map { MuscleGroupVolume(muscleGroup: $0.key, volume: $0.value) }
            .sorted { $0.volume > $1.volume }
    }

    func calculateWorkoutScore(_ workout: Workout, modelContext: ModelContext) -> Int {
        let volume = workout.totalVolume
        let duration = workout.endDate?.timeIntervalSince(workout.startDate) ?? 0
        let exerciseCount = workout.exercises.count
        let setCount = workout.exercises.reduce(0) { $0 + $1.sets.filter(\.isCompleted).count }

        let lastWorkouts = recentWorkouts.prefix(5)
        let avgVolume = lastWorkouts.isEmpty ? volume : lastWorkouts.map(\.totalVolume).reduce(0, +) / Double(lastWorkouts.count)

        let volumeScore = min(30, Int((volume / max(avgVolume, 1)) * 15))
        let varietyScore = min(25, exerciseCount * 5)
        let efficiencyScore = min(25, setCount * 2)
        let durationScore = duration > 0 ? min(20, Int(20 * min(duration / 3600, 1.0))) : 10

        return min(100, volumeScore + varietyScore + efficiencyScore + durationScore)
    }
}
