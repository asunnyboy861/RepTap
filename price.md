# Pricing Configuration

## Monetization Model: Freemium + One-Time Purchase (Non-Consumable IAP)

RepTap uses a "Free forever + Pro one-time unlock" model. This is the core differentiator against competitors who trap users with subscriptions.

## Free Tier (Forever Free)

- **Price**: Free
- **Workout Logging**: Unlimited (no cap on workouts, sets, exercises)
- **Exercise Database**: 300+ exercises included
- **Custom Exercises**: Unlimited creation
- **Workout Templates**: Unlimited creation and reuse
- **Rest Timer**: Auto-start with configurable duration
- **HealthKit Sync**: Full integration (read + write)
- **iCloud Sync**: Cross-device sync included
- **Data Export**: CSV and JSON export included
- **PR Auto-Detection**: Automatic PR tracking
- **Apple Watch**: Basic workout logging
- **Ads**: Zero ads forever
- **Purpose**: Let users fully depend on RepTap, form habits, become unable to leave

## Pro Tier — One-Time Purchase

- **Reference Name**: RepTap Pro
- **Product ID**: `com.zzoutuo.RepTap.pro`
- **Price**: $14.99 (one-time, never pay again)
- **Display Name**: RepTap Pro
- **Description**: Unlock advanced insights forever
- **Type**: Non-Consumable In-App Purchase

### Pro Features Unlocked

| Feature | Description |
|---------|-------------|
| Smart Progression Suggestions | AI-powered weight/reps recommendations based on 4-week history |
| Advanced Charts | Deep volume trend analysis with Swift Charts |
| Muscle Heatmap | Visual muscle group training distribution |
| Workout Score | 0-100 score based on volume, PRs, variety, efficiency |
| Body Measurements | Track weight, body fat, and circumference measurements |
| Apple Watch Live Activities | Lock screen rest timer via ActivityKit |
| Dark/Light Theme Customization | Custom theme options |
| Bulk Data Import | Migrate from Strong/Hevy |
| Priority Feature Requests | Vote on future features |

### Pricing Rationale

- $14.99 = 1/4 of one month's gym membership
- $14.99 = 1/2 to 1/6 of competitor annual subscriptions
- $14.99 = price of one coffee + protein bar
- One-time = "honest pricing" promise fulfilled
- No subscription = zero psychological burden, extremely low purchase friction

### 3-Year Cost Comparison

| App | 3-Year Total Cost |
|-----|-------------------|
| Fitbod | $287.97 |
| Strong | $89.97 |
| Hevy | $71.97 |
| **RepTap** | **$14.99** |

## Promotional Pricing Strategy

| Period | Price | Discount | Purpose |
|--------|-------|----------|---------|
| Launch (0-3 months) | $9.99 | 33% off | Early adopter acquisition |
| New Year (January) | $11.99 | 20% off | New Year resolution wave |
| Summer (May-June) | $11.99 | 20% off | Summer fitness wave |
| Black Friday (November) | $9.99 | 33% off | Annual biggest sale |

## Non-Intrusive Upsell Triggers

| Trigger | User Behavior | Shown Content | Frequency |
|---------|---------------|---------------|-----------|
| Workout Complete | Finish workout | "💡 Try 140 lbs × 8 — Unlock with Pro" | Once per workout |
| Progress Page | View Progress tab | Locked advanced charts + "See volume trends — Pro" | Once per visit |
| PR Celebration | New PR achieved | "🏆 See your PR history — Pro" | Once per PR |
| Apple Watch | First Watch use | "Live Activities on lock screen — Pro" | Once ever |
| 10th Workout | Milestone | "🎉 10 workouts! Unlock advanced insights — Pro $14.99 once" | Once ever |
| 30th Day | Loyal user | "You've trained 30 days! Go Pro for deeper insights" | Once ever |

**Key Principle**: Never pop-up, never force, only show Pro value when user naturally explores.

## App Store Connect Pricing

- **App Price**: Free (Tier 0)
- **IAP Product**: Non-Consumable
  - Product ID: `com.zzoutuo.RepTap.pro`
  - Price Tier: $14.99
  - Review Note: One-time purchase, no subscription, no trial

## Policy Pages Required

- Support Page: ✅
- Privacy Policy: ✅
- Terms of Use: ✅ (Required for IAP — Apple Guideline 3.1.2)

## Apple IAP Compliance Checklist

- [x] Non-consumable product type (one-time purchase)
- [x] No dark patterns or forced upsell
- [x] Restore purchases functionality will be implemented
- [x] Clear pricing displayed before purchase
- [x] No subscription — no auto-renewal terms needed
- [x] Free tier is fully functional without Pro
- [x] Terms of Use page will be provided
