import Foundation

extension Double {
    var formattedWeight: String {
        if self == floor(self) {
            return "\(Int(self)) lbs"
        }
        return String(format: "%.1f lbs", self)
    }

    var formattedVolume: String {
        if self >= 1000 {
            return String(format: "%.1fk", self / 1000)
        }
        if self == floor(self) {
            return "\(Int(self))"
        }
        return String(format: "%.1f", self)
    }
}
