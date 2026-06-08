# Capabilities Configuration

## Analysis
Based on operation guide analysis, the following capabilities are required:
- "健康" / "HealthKit" / "health" → HealthKit
- "同步" / "iCloud" / "CloudKit" → iCloud
- "购买" / "Pro" / "premium" / "买断" → In-App Purchase
- "手表" / "Watch" / "watchOS" → Apple Watch (future target)
- "Live Activity" / "ActivityKit" → Live Activity (future target)

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| HealthKit | ✅ Configured | Entitlements file + Info.plist keys (NSHealthShareUsageDescription, NSHealthUpdateUsageDescription) |
| iCloud (CloudKit) | ✅ Configured | Entitlements file (com.apple.developer.icloud-container-identifiers, com.apple.developer.icloud-key-value-store, com.apple.developer.ubiquity-container-identifiers) |
| In-App Purchase | ✅ Configured | Entitlements file (com.zzoutuo.RepTap.pro product ID) |
| Code Signing Entitlements | ✅ Configured | Added CODE_SIGN_ENTITLEMENTS to both Debug and Release build configurations |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| CloudKit Container | ⏳ Pending | 1. Open Apple Developer Portal → Identifiers → App IDs → com.zzoutuo.RepTap → Enable CloudKit → Create container "iCloud.com.zzoutuo.RepTap" |
| App Store Connect IAP | ⏳ Pending | 1. Open App Store Connect → In-App Purchases → Create non-consumable product ID "com.zzoutuo.RepTap.pro" with price $14.99 |
| Apple Watch Target | ⏳ Pending | Add watchOS target in Xcode (will be done during code generation) |
| Live Activity | ⏳ Pending | Add ActivityKit capability (will be done during code generation) |

## No Configuration Needed
- Push Notifications (not required)
- Location Services (not required)
- Camera/Photo Library (not required)
- Siri (not required)
- Sign in with Apple (not required)
- Background Modes (not required for MVP)

## Verification
- Build succeeded after configuration: Pending verification
- All entitlements correct: ✅
