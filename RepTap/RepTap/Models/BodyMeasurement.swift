import Foundation
import SwiftData

@Model
final class BodyMeasurement {
    var date: Date
    var weight: Double
    var bodyFatPercentage: Double
    var armCircumference: Double
    var chestCircumference: Double
    var waistCircumference: Double
    var thighCircumference: Double

    init(date: Date = .now, weight: Double = 0, bodyFatPercentage: Double = 0, armCircumference: Double = 0, chestCircumference: Double = 0, waistCircumference: Double = 0, thighCircumference: Double = 0) {
        self.date = date
        self.weight = weight
        self.bodyFatPercentage = bodyFatPercentage
        self.armCircumference = armCircumference
        self.chestCircumference = chestCircumference
        self.waistCircumference = waistCircumference
        self.thighCircumference = thighCircumference
    }
}
