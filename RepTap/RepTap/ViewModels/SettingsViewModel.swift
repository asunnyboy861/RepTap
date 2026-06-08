import Foundation
import SwiftData
import Observation

@MainActor @Observable
class SettingsViewModel {
    var isPro = false
    var defaultRestSeconds: Int = 90
    var weightUnit: WeightUnit = .lbs
    var iCloudSyncEnabled = true
    var hasCompletedOnboarding: Bool {
        UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }

    enum WeightUnit: String, CaseIterable {
        case lbs = "lbs"
        case kg = "kg"
    }

    func loadSettings() {
        defaultRestSeconds = UserDefaults.standard.integer(forKey: "defaultRestSeconds").nonZeroOr(90)
        weightUnit = WeightUnit(rawValue: UserDefaults.standard.string(forKey: "weightUnit") ?? "lbs") ?? .lbs
        iCloudSyncEnabled = UserDefaults.standard.bool(forKey: "iCloudSyncEnabled") || !UserDefaults.standard.objectIs(forKey: "iCloudSyncEnabled")
    }

    func saveDefaultRest(_ seconds: Int) {
        defaultRestSeconds = seconds
        UserDefaults.standard.set(seconds, forKey: "defaultRestSeconds")
    }

    func saveWeightUnit(_ unit: WeightUnit) {
        weightUnit = unit
        UserDefaults.standard.set(unit.rawValue, forKey: "weightUnit")
    }

    func saveiCloudSync(_ enabled: Bool) {
        iCloudSyncEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "iCloudSyncEnabled")
    }

    func markOnboardingComplete() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}

extension UserDefaults {
    func objectIs(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}
