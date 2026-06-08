import UIKit

struct HapticService {
    static func logSet() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func prCelebration() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func restComplete() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    static func buttonTap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
