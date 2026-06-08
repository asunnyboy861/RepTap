# RepTap - iOS Development Guide

## Executive Summary

**RepTap** is an honest, simple, privacy-first workout tracker for iOS that lets users log sets and reps in seconds. The app's core philosophy is "Less UI, More Lifting" — every interaction is optimized for speed, with a 2-step Tap-to-Log system that auto-fills previous weight and reps.

**Product Vision**: Become the most trusted workout tracker by offering unlimited free logging, zero ads, zero subscriptions, and a one-time Pro purchase at $14.99 — standing in stark contrast to competitors who trap users with deceptive subscriptions ($24-96/year).

**Target Audience**: US gym-goers aged 18-45 who want a fast, honest workout logger without subscription fatigue.

**Key Differentiators**:
1. **Honest Pricing**: No subscriptions ever. Free forever for core logging. One-time $14.99 Pro unlock.
2. **2-Step Logging**: Confirm weight → Tap Done. Previous values auto-filled.
3. **Privacy First**: All data stored locally + iCloud sync. No cloud servers. No data collection.
4. **Fully Offline**: Works perfectly in gym basements with no signal.
5. **Zero Ads**: Free version has no ads, ever.

**Technical Stack**: Swift + SwiftUI + SwiftData + HealthKit + CloudKit + watchOS + StoreKit 2

## Competitive Analysis

| App | Strengths | Weaknesses | RepTap Advantage |
|-----|-----------|------------|------------------|
| **Strong** | Clean UI, Apple Watch, 4.9 rating | $29.99/yr subscription, no lifetime, 3-routine free tier | Unlimited free logging + one-time purchase + progression suggestions |
| **Hevy** | Social features, $74.99 lifetime, Hevy Trainer AI | Free tier has ads, capped at 4 routines, cloud-only storage | Zero ads + iCloud privacy + no subscription fatigue |
| **Fitbod** | AI-generated workouts, large exercise library | $95.99/yr (!!!), only 3 free workouts, no lifetime option | 1/10th the price + unlimited free + no subscription |
| **JEFIT** | Large exercise database, community | Ads in free version, outdated UI, 4.5 rating | Zero ads + modern SwiftUI + Liquid Glass design |
| **RepCount** | Fast logging, generous free tier, 4.9 rating | Limited advanced analytics, no Watch app | Apple Watch + progression suggestions + muscle heatmap |

## Feature Inventory

### Primary Features

| # | Feature | User Operation Flow | Data Input | Processing | Data Output | Persistence | Acceptance Criteria |
|---|---------|--------------------|------------|------------|-------------|-------------|---------------------|
| 1 | **Tap-to-Log Workout Recording** | 1. Open app → 2. Tap "Start Workout" → 3. Confirm weight (auto-filled) → 4. Tap Done | Weight (Double), Reps (Int) — auto-filled from previous set | Validate weight/reps > 0, calculate volume (weight × reps), check for PR | Set logged with green checkmark, haptic feedback, auto-start rest timer | SwiftData ExerciseSet entity | User can log a set in 2 taps within 3 seconds |
| 2 | **Exercise Database (300+)** | 1. Tap "Add Exercise" → 2. Search or browse by muscle group → 3. Select exercise | Search text, muscle group filter | Filter exercises by name/muscle group, return matching results | List of matching exercises with muscle group tags | SwiftData Exercise entities, bundled JSON database | User can find any exercise within 5 seconds |
| 3 | **Workout Templates (Routines)** | 1. Go to Routines tab → 2. Tap "+" → 3. Name routine → 4. Add exercises → 5. Save | Template name, exercise selections, target sets/reps | Validate template has name + at least 1 exercise | Saved template appears in Routines list | SwiftData WorkoutTemplate + TemplateExercise | User can create and reuse a routine |
| 4 | **Auto Rest Timer** | 1. Log a set → 2. Timer auto-starts with configured duration → 3. Haptic alert when done | Default rest time from settings (Int seconds) | Countdown timer, trigger haptic + sound at 0 | Visual countdown bar, haptic at completion | UserDefaults defaultRestTime | Timer starts automatically after each set |
| 5 | **PR Auto-Detection** | 1. Log a set → 2. System checks against historical PRs → 3. If PR, show celebration | Weight, reps from logged set | Calculate Epley 1RM, compare to existing PRs for 1RM/3RM/5RM/10RM/MaxWeight/MaxVolume | PR celebration overlay with confetti animation | SwiftData PersonalRecord entity | New PR detected and celebrated within 1 second of logging |
| 6 | **Progress Charts** | 1. Tap Progress tab → 2. View volume trends, PR list, weekly stats | Date range, exercise filter | Aggregate workout data by week/month, calculate volume trends | Swift Charts visualizations (volume trend, PR timeline) | Read from SwiftData Workout/ExerciseSet | User sees accurate weekly/monthly volume chart |
| 7 | **HealthKit Integration** | 1. Onboarding → 2. Authorize HealthKit → 3. Auto-sync on workout completion | Workout start/end time, exercises, total volume | Create HKWorkout with .traditionalStrengthTraining type | Workout saved to Apple Health | HKHealthStore | Completed workout appears in Apple Health |
| 8 | **iCloud Sync** | 1. Enable in Settings → 2. Auto-sync in background | SwiftData model changes | CloudKit automatic sync via ModelConfiguration | Data synced across iPhone/iPad/Watch | CloudKit .automatic database | Data persists across devices |
| 9 | **Apple Watch App** | 1. Raise wrist → 2. See current exercise → 3. Adjust weight/reps via Crown → 4. Tap to log | Weight, reps via Digital Crown | Same as iPhone logging logic | Set logged, rest timer starts on Watch | Watch shared SwiftData container | User can log a set on Watch in 3 seconds |
| 10 | **Data Export** | 1. Go to Settings → 2. Tap "Export Data" → 3. Choose CSV or JSON → 4. Share | Export format selection | Serialize all workout data to CSV/JSON | Share sheet with file | Read from SwiftData | User can export complete workout history |
| 11 | **Smart Progression Suggestions (Pro)** | 1. During workout → 2. After logging a set → 3. See "Try 140 lbs × 8" suggestion | Current weight, reps, exercise ID | Analyze last 4 weeks of sets, calculate completion rate + avg RPE, apply progression algorithm | Suggested weight/reps with confidence level | Read from SwiftData ExerciseSet history | Suggestion appears after each set with reasoning |
| 12 | **Advanced Charts (Pro)** | 1. Tap Progress tab → 2. Scroll to Pro section → 3. View volume trends, muscle heatmap | Date range, exercise/muscle group filter | Aggregate by week/month/year, calculate muscle group distribution | Swift Charts deep analysis + muscle heatmap visualization | Read from SwiftData | Pro charts render with 12+ months of data |
| 13 | **Workout Score (Pro)** | 1. Complete workout → 2. See score 0-100 | All sets in workout, total volume, duration | Score based on volume vs previous, PR count, exercise variety, duration efficiency | Score display with breakdown | Calculated on-the-fly | Score appears on workout completion screen |
| 14 | **Body Measurements (Pro)** | 1. Go to Progress → Body → 2. Enter weight/body fat/measurements → 3. Save | Weight, body fat %, arm/chest/waist/thigh measurements | Validate ranges, calculate trends | Body measurement chart over time | SwiftData BodyMeasurement entity | User can track and chart body measurements |
| 15 | **Pro Purchase (StoreKit 2)** | 1. Tap Pro feature → 2. See Pro paywall → 3. Tap "Unlock Pro $14.99" → 4. Purchase | Product ID: com.zzoutuo.RepTap.pro | StoreKit 2 purchase flow, verify transaction | isPro flag set to true, Pro features unlocked | StoreKit Transaction + UserDefaults | One-time purchase unlocks all Pro features forever |
| 16 | **Live Activity (Pro)** | 1. Start workout → 2. Lock screen shows rest timer → 3. Timer counts down | Rest timer state from workout | ActivityKit update push | Lock screen/dynamic island rest timer | ActivityKit | Rest timer visible on lock screen during workout |
| 17 | **Onboarding** | 1. First launch → 2. Welcome → 3. Select training type → 4. HealthKit auth → 5. Done | Training type selection, HealthKit authorization | Save preferences, request HK auth | User lands on Home ready to work out | UserDefaults + HKHealthStore | New user completes onboarding in under 30 seconds |

### Sub-Features & Detail Interactions

| # | Parent Feature | Sub-Feature | Detail Description | Interaction Pattern |
|---|---------------|-------------|-------------------|--------------------|
| 1.1 | Tap-to-Log | Auto-fill previous values | Weight and reps auto-populate from the last set of the same exercise | Automatic on exercise selection |
| 1.2 | Tap-to-Log | Quick weight increment | +/- buttons to adjust weight by standard plates (2.5/5 lbs) | Tap +/- buttons |
| 1.3 | Tap-to-Log | Set completion indicator | Green checkmark on completed sets, gray on pending | Visual state change |
| 2.1 | Exercise Database | Custom exercise creation | User can create exercises not in the database with custom name, muscle group, equipment | Tap "Create Custom" in exercise picker |
| 2.2 | Exercise Database | Muscle group filtering | Filter exercises by Chest, Back, Shoulders, Arms, Legs, Core | Tap muscle group chips |
| 3.1 | Routines | Start workout from routine | One-tap to start a workout using a saved routine template | Tap "Start" on routine card |
| 3.2 | Routines | Edit routine | Add/remove exercises, reorder, change target sets/reps | Swipe to edit, drag to reorder |
| 4.1 | Rest Timer | Custom rest time per exercise | Override default rest time for specific exercises | Tap timer to adjust |
| 4.2 | Rest Timer | Skip rest | Tap to skip remaining rest time | Tap "Skip" button |
| 5.1 | PR Detection | Multiple PR types | Track 1RM, 3RM, 5RM, 10RM, MaxWeight, MaxVolume | Automatic detection |
| 5.2 | PR Detection | PR history | View all PRs for an exercise over time | Tap PR in list to see history |
| 6.1 | Progress | Weekly streak | Show consecutive training days this week | Visual streak indicator on Home |
| 6.2 | Progress | Volume trend chart | Line chart showing total volume per week over time | Auto-generated Swift Chart |
| 9.1 | Apple Watch | Digital Crown input | Rotate crown to adjust weight/reps values | Physical crown rotation |
| 9.2 | Apple Watch | Haptic rest timer | Wrist tap when rest period ends | Automatic haptic |
| 11.1 | Progression | Confidence indicator | Show confidence level (Low/Medium/High) based on sample size | Visual indicator next to suggestion |
| 11.2 | Progression | Deload suggestion | Suggest reducing weight when completion rate is low | Text suggestion with reasoning |
| 15.1 | Pro Purchase | Restore purchases | Restore previously purchased Pro on new device | Tap "Restore Purchases" in Settings |
| 15.2 | Pro Purchase | Non-intrusive upsell | Pro features shown with lock icon, never pop-up or force | Tap locked feature to see Pro paywall |

### Cross-Feature Dependencies

| Dependency | Source Feature | Target Feature | Data Passed | Trigger Condition |
|------------|---------------|----------------|-------------|-------------------|
| Set logged → PR check | Tap-to-Log | PR Detection | weight, reps, exerciseId | Every set completion |
| Set logged → Progression suggestion | Tap-to-Log | Progression (Pro) | weight, reps, exerciseId | Every set completion |
| Workout complete → HealthKit sync | Tap-to-Log | HealthKit | startDate, endDate, exercises, volume | Workout finish |
| Workout complete → iCloud sync | Tap-to-Log | iCloud Sync | Full workout object | Workout finish |
| PR detected → Celebration | PR Detection | Tap-to-Log UI | PR object | New PR found |
| Template → Workout | Routines | Tap-to-Log | TemplateExercise list | Start workout from routine |
| Set logged → Rest timer | Tap-to-Log | Rest Timer | restSeconds from exercise | Every set completion |
| Pro check → Feature access | Pro Purchase | All Pro features | isPro boolean | User taps Pro feature |
| Watch set → iPhone sync | Apple Watch | Tap-to-Log | weight, reps | Set logged on Watch |
| Workout complete → Workout Score | Tap-to-Log | Workout Score (Pro) | All sets, volume, duration | Workout finish |

## Apple Design Guidelines Compliance

- **Liquid Glass**: Adopt iOS 26 Liquid Glass materials for navigation bars, cards, and buttons. Use `.ultraThinMaterial` for backgrounds, `.regularMaterial` for cards, `.thickMaterial` for buttons. Respect Reduced Transparency accessibility setting.
- **Haptic Feedback**: Use UIImpactFeedbackGenerator for set logging, UINotificationFeedbackGenerator for PR celebrations. Respect Reduced Motion setting.
- **HealthKit**: Must provide clear privacy description in Info.plist ("Sync your workouts to Apple Health"). Request authorization only at onboarding.
- **Privacy**: All data stored locally + iCloud. No third-party data collection. Privacy policy required.
- **Accessibility**: Dynamic Type support, VoiceOver labels on all interactive elements, minimum 44pt touch targets, 4.5:1 contrast ratios.
- **App Store Review**: Health & Fitness category. Age rating 4+. No user-generated content. Data collection declaration: "No data collected."

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), UIKit (HapticService only)
- **Data**: SwiftData + CloudKit automatic sync
- **Health**: HealthKit (HKWorkout for strength training)
- **Payments**: StoreKit 2 (one-time non-consumable)
- **Watch**: watchOS 10.0+ with WatchConnectivity
- **Widgets**: WidgetKit (Streak, Weekly Summary)
- **Live Activity**: ActivityKit (rest timer on lock screen)
- **Charts**: Swift Charts framework
- **Architecture**: MVVM (View → ViewModel → SwiftData Model)

## Module Structure

```
RepTap/
├── RepTapApp.swift                    # @main entry + ModelContainer
├── Models/
│   ├── Workout.swift                  # SwiftData @Model
│   ├── WorkoutExercise.swift          # SwiftData @Model
│   ├── ExerciseSet.swift              # SwiftData @Model
│   ├── Exercise.swift                 # SwiftData @Model
│   ├── PersonalRecord.swift           # SwiftData @Model
│   ├── WorkoutTemplate.swift          # SwiftData @Model
│   ├── TemplateExercise.swift         # SwiftData @Model
│   ├── UserPreference.swift           # SwiftData @Model
│   └── BodyMeasurement.swift          # SwiftData @Model (Pro)
├── ViewModels/
│   ├── WorkoutViewModel.swift         # Active workout state management
│   ├── ExerciseViewModel.swift        # Exercise selection/search
│   ├── ProgressViewModel.swift        # Progress analytics
│   └── SettingsViewModel.swift        # Settings + Pro state
├── Views/
│   ├── Home/
│   │   ├── HomeView.swift             # Main dashboard
│   │   ├── StreakCardView.swift       # Training streak card
│   │   └── RecentRoutinesView.swift   # Recent routine cards
│   ├── Workout/
│   │   ├── ActiveWorkoutView.swift    # Active workout screen
│   │   ├── SetLoggingView.swift       # Tap-to-Log set entry
│   │   ├── RestTimerView.swift        # Rest countdown timer
│   │   ├── WorkoutCompleteView.swift  # Workout summary
│   │   └── PRCelebrationView.swift    # PR confetti animation
│   ├── History/
│   │   ├── HistoryView.swift          # Workout history list
│   │   └── WorkoutDetailView.swift    # Single workout detail
│   ├── Progress/
│   │   ├── ProgressView.swift         # Progress dashboard
│   │   ├── PRListView.swift           # PR list
│   │   ├── VolumeChartView.swift      # Volume trend chart
│   │   ├── MuscleHeatmapView.swift    # Muscle heatmap (Pro)
│   │   └── BodyMeasurementView.swift  # Body tracking (Pro)
│   ├── Routines/
│   │   ├── RoutinesView.swift         # Template management
│   │   └── RoutineEditorView.swift    # Template editor
│   ├── Settings/
│   │   ├── SettingsView.swift         # Settings page
│   │   ├── ProPurchaseView.swift      # Pro paywall
│   │   └── DataExportView.swift       # CSV/JSON export
│   └── Onboarding/
│       ├── WelcomeView.swift          # Welcome screen
│       ├── HealthKitAuthView.swift    # HealthKit authorization
│       └── TrainingTypeView.swift     # Training type selection
├── Services/
│   ├── HealthKitService.swift         # HealthKit integration
│   ├── ProgressionService.swift       # Smart progression algorithm
│   ├── PRDetectionService.swift       # PR auto-detection
│   ├── HapticService.swift            # Haptic feedback engine
│   ├── BackupService.swift            # Data import/export
│   └── StoreKitService.swift          # Pro purchase management
├── Resources/
│   ├── ExerciseDatabase.json          # 300+ exercise database
│   └── Assets.xcassets                # Image assets
├── Extensions/
│   ├── Date+Extensions.swift          # Date formatting
│   ├── Double+Extensions.swift        # Weight formatting
│   └── Color+Extensions.swift         # Custom colors
├── RepTapWatch/                       # Apple Watch app
│   ├── RepTapWatchApp.swift
│   ├── Views/
│   │   ├── WatchWorkoutView.swift     # Watch workout logging
│   │   └── WatchRestTimerView.swift   # Watch rest timer
│   └── Services/
│       └── WatchConnectivityService.swift
├── RepTapWidget/                      # Home screen widgets
│   ├── StreakWidget.swift             # Training streak widget
│   └── WeeklySummaryWidget.swift      # Weekly summary widget
└── RepTapLiveActivity/                # Live Activity
    └── RestTimerLiveActivity.swift    # Lock screen rest timer
```

## Data Flow Diagram

### Feature 1: Tap-to-Log Workout Recording
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Tap "Start Workout" → Select exercise → Confirm     │
│     weight (auto-filled) → Tap "Done"                    │
│       │                                                   │
│  ViewModel Processing                                     │
│  └── WorkoutViewModel.logSet() → validate weight/reps    │
│     → calculate volume → check PR → trigger haptic       │
│       │                                                   │
│  Model/Persistence                                        │
│  └── ExerciseSet SwiftData entity → modelContext.insert  │
│     → Workout.totalVolume updated → auto-save            │
│       │                                                   │
│  Display Output                                           │
│  └── Green checkmark on set → rest timer auto-starts     │
│     → PR celebration if new PR → progression suggestion   │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── PR Detection → HealthKit (on workout complete)      │
│     → iCloud sync (automatic) → Progress charts data     │
└───────────────────────────────────────────────────────────┘
```

### Feature 5: PR Auto-Detection
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── (Automatic — triggered by set logging)               │
│       │                                                   │
│  ViewModel Processing                                     │
│  └── WorkoutViewModel → PRDetectionService.checkForPR()  │
│     → calculate Epley 1RM → compare to existing PRs      │
│       │                                                   │
│  Model/Persistence                                        │
│  └── PersonalRecord SwiftData entity → insert new PR     │
│     → update previousValue on old PR                      │
│       │                                                   │
│  Display Output                                           │
│  └── PRCelebrationView overlay with confetti animation   │
│     → haptic success feedback → "New PR!" badge          │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── PRListView data → Progress charts → Watch sync      │
└───────────────────────────────────────────────────────────┘
```

### Feature 11: Smart Progression Suggestions (Pro)
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── (Automatic — triggered by set logging, Pro only)     │
│       │                                                   │
│  ViewModel Processing                                     │
│  └── WorkoutViewModel → ProgressionService.suggest()     │
│     → fetchRecentSets(4 weeks) → calculateCompletionRate │
│     → calculateAverageRPE → apply progression algorithm  │
│       │                                                   │
│  Model/Persistence                                        │
│  └── Read from ExerciseSet history (no write)             │
│       │                                                   │
│  Display Output                                           │
│  └── "💡 Try 140 lbs × 8" suggestion card               │
│     → confidence indicator → reasoning text               │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── None (suggestion is display-only)                    │
└───────────────────────────────────────────────────────────┘
```

### Feature 15: Pro Purchase
```
┌───────────────────────────────────────────────────────────┐
│  User Input                                               │
│  └── Tap locked Pro feature → See paywall → Tap purchase │
│       │                                                   │
│  ViewModel Processing                                     │
│  └── SettingsViewModel → StoreKitService.purchasePro()   │
│     → Product.products(for: ["com.zzoutuo.RepTap.pro"])  │
│     → product.purchase() → verify transaction             │
│       │                                                   │
│  Model/Persistence                                        │
│  └── StoreKit Transaction → isPro flag in UserDefaults   │
│     → transaction.finish()                                │
│       │                                                   │
│  Display Output                                           │
│  └── Pro features unlocked → lock icons removed          │
│     → confirmation toast                                  │
│       │                                                   │
│  Cross-Feature Output                                     │
│  └── All Pro features check isPro boolean                 │
└───────────────────────────────────────────────────────────┘
```

## Implementation Flow

1. Create Xcode project with SwiftData + CloudKit + HealthKit + Watch targets
2. Define SwiftData models (Workout, WorkoutExercise, ExerciseSet, Exercise, PersonalRecord, WorkoutTemplate, TemplateExercise, UserPreference, BodyMeasurement)
3. Build Exercise database JSON (300+ exercises organized by muscle group)
4. Implement Services layer (HealthKitService, ProgressionService, PRDetectionService, HapticService, BackupService, StoreKitService)
5. Build Onboarding flow (Welcome → Training Type → HealthKit Auth)
6. Build Home screen (Streak card, Start Workout button, Recent routines)
7. Build Active Workout flow (exercise selection, Tap-to-Log, rest timer, workout complete)
8. Build Routines management (create, edit, start from template)
9. Build History view (workout list, workout detail)
10. Build Progress view (charts, PR list, volume trends)
11. Build Settings (weight unit, rest timer, HealthKit, iCloud, Pro purchase, data export)
12. Build Apple Watch app (workout logging, rest timer)
13. Build Widgets (Streak, Weekly Summary)
14. Build Live Activity (lock screen rest timer)
15. Integrate StoreKit 2 for Pro purchase
16. Test and verify all features

## UI/UX Design Specifications

- **Design Philosophy**: "Less UI, More Lifting" — minimize taps, maximize lifting
- **Color Scheme**:
  - Primary: #FF6B35 (Energetic Orange) — action buttons, active states, PR highlights
  - Success: #34C759 (Green) — completed sets, PRs
  - Info: #007AFF (Blue) — links, information
  - Warning: #FF9500 (Amber) — rest timer
  - Background Dark: #1C1C1E, Card Dark: #2C2C2E
  - Background Light: #F2F2F7, Card Light: #FFFFFF
- **Liquid Glass Materials**:
  - Background: `.ultraThinMaterial` (20% opacity)
  - Cards: `.regularMaterial` (40% opacity) + 16pt corner radius
  - Buttons: `.thickMaterial` (60% opacity) + 12pt corner radius
  - Modals: `.thickMaterial` + blur effect
- **Typography**:
  - Exercise name during workout: SF Pro Rounded 28pt Bold
  - Weight/Reps numbers: SF Pro Monospaced 36pt Heavy
  - TAP button text: SF Pro Rounded 14pt Black
  - Page title: SF Pro Rounded 22pt Bold
  - Body: SF Pro 16pt Regular
  - Caption: SF Pro 13pt Medium
- **Spacing**: 20pt page margins, 16pt card padding, 16pt card corner radius
- **Touch Targets**: Minimum 44pt, TAP button 80pt height
- **Animations**: Spring animations for PR celebrations, smooth transitions between exercises
- **Haptics**: Medium impact on set log, double success on PR, warning on rest timer end

## Code Generation Rules

- MVVM architecture: View → ViewModel → SwiftData Model
- SwiftData + CloudKit for persistence, local-first
- async/await + @MainActor, no Combine
- @State + @Bindable + @Query + @Observable for state management
- PascalCase for types, camelCase for properties/methods
- No comments in code unless explicitly requested
- Minimum iOS 17.0 / watchOS 10.0
- Swift 5.9+, SwiftUI only (UIKit for HapticService only)
- String Catalog for internationalization, default English
- One feature per module, high cohesion, low coupling
- Apple native first: SwiftUI, Swift Charts, StoreKit 2, ActivityKit
- Open source first: reference SetDeck (MIT) for base architecture

## Build & Deployment Checklist

- [ ] Xcode project created with all targets (iOS, Watch, Widget, Live Activity)
- [ ] SwiftData models defined with CloudKit configuration
- [ ] HealthKit capability added with NSHealthShareUsageDescription + NSHealthUpdateUsageDescription
- [ ] StoreKit 2 non-consumable product configured
- [ ] App Icon generated and set
- [ ] Bundle ID: com.zzoutuo.RepTap
- [ ] Minimum iOS: 17.0
- [ ] watchOS 10.0+ for Watch target
- [ ] Privacy Policy URL hosted (GitHub Pages)
- [ ] Support URL hosted (GitHub Pages)
- [ ] Terms of Use URL hosted (GitHub Pages)
- [ ] App Store Connect metadata prepared
- [ ] Age rating: 4+
- [ ] Category: Health & Fitness
- [ ] Data collection: None declared
