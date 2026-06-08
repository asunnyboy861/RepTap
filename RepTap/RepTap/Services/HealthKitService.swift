import Foundation
import HealthKit

@MainActor
class HealthKitService {
    private let healthStore = HKHealthStore()

    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization() async -> Bool {
        guard isAvailable else { return false }

        let types: Set<HKSampleType> = [
            HKObjectType.workoutType(),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.heartRate)
        ]

        do {
            try await healthStore.requestAuthorization(toShare: types, read: types)
            return true
        } catch {
            return false
        }
    }

    func saveWorkout(startDate: Date, endDate: Date, totalVolume: Double, exercises: [WorkoutExercise]) async {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .traditionalStrengthTraining

        let energyBurned = HKQuantity(unit: .kilocalorie(), doubleValue: totalVolume * 0.05)
        let workout = HKWorkout(
            activityType: .traditionalStrengthTraining,
            start: startDate,
            end: endDate,
            duration: endDate.timeIntervalSince(startDate),
            totalEnergyBurned: energyBurned,
            totalDistance: nil,
            metadata: [HKMetadataKeyWorkoutBrandName: "RepTap"]
        )

        do {
            try await healthStore.save(workout)
        } catch {
            print("HealthKit save error: \(error)")
        }
    }
}
