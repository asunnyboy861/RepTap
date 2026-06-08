# RepTap — 配置文档

生成时间：2026-06-08

---

## 一、⚠️ 手动配置（需你操作才能生效）

### 🔴 Capabilities 配置

#### CloudKit Container — iCloud 数据同步

**影响功能**：不配置则 iCloud 同步不可用，数据仅存本地

**已自动配置部分**：
- ✅ Xcode Signing & Capabilities 中已启用 iCloud
- ✅ .entitlements 中已添加 `com.apple.developer.icloud-container-identifiers`、`com.apple.developer.icloud-key-value-store`、`com.apple.developer.ubiquity-container-identifiers`

**仍需手动配置**：
1. 打开 [Apple Developer](https://developer.apple.com)
2. 进入 **Certificates, Identifiers & Profiles** → **Identifiers**
3. 找到 `com.zzoutuo.RepTap` → 点击编辑
4. 勾选 **iCloud** → 点击 **Configure**
5. 创建 CloudKit Container：`iCloud.com.zzoutuo.RepTap`
6. 点击 **Save** → **Confirm**
7. ⚠️ 配置完成后需要重新 Build 验证

---

### 🔵 IAP StoreKit 配置

**影响功能**：不创建 IAP 产品则用户无法购买 RepTap Pro

**配置步骤**：
1. 打开 [App Store Connect](https://appstoreconnect.apple.com)
2. 进入你的 App → **Features** → **In-App Purchases**
3. 点击 **"+"** 创建非消耗型产品

| 产品 | Reference Name | Product ID | 类型 | 价格 |
|------|---------------|-----------|------|------|
| RepTap Pro | RepTap Pro | `com.zzoutuo.RepTap.pro` | Non-Consumable | $14.99 |

4. 填写 Display Name：**RepTap Pro**
5. 填写 Description：**Unlock advanced insights forever**
6. ⚠️ 创建后需要等待 Apple 审核（通常1-2小时）
7. 在 Xcode 中创建 StoreKit Configuration File 用于本地测试：
   - File → New → File → StoreKit Configuration File
   - 命名为 `RepTapStoreKit.storekit`
   - 添加 Non-Consumable Product，Product ID 填 `com.zzoutuo.RepTap.pro`，Price 填 $14.99
   - 在 Scheme → Edit Scheme → Run → Options → StoreKit Configuration 选择该文件
8. 在 SettingsView 中点击 **"Restore Purchases"** 验证流程

---

### 🟢 App Store Connect 审核信息配置

**影响功能**：不配置则 Apple 审核员无法测试 IAP 功能，可能导致 Guideline 2.1 拒绝

**配置步骤**：
1. 在 App Store Connect → 你的 App → **App Review Information**
2. 在 **Notes** 字段中说明：
   - 此 App 使用一次性购买（Non-Consumable IAP），Product ID: `com.zzoutuo.RepTap.pro`
   - 免费功能完整可用，Pro 为高级分析功能
   - 无订阅、无自动续费
3. ⚠️ 确保 **Privacy Policy URL** 填写：`https://asunnyboy861.github.io/RepTap/privacy.html`
4. ⚠️ 确保 App Store Connect 的 **EULA** 或 Description 中包含 Terms of Use 链接：`https://asunnyboy861.github.io/RepTap/terms.html`

---

## 二、✅ 自动配置记录（已由系统完成，无需操作）

### Capabilities 自动配置

| Capability | 说明 | 状态 |
|------------|------|------|
| HealthKit | Entitlements + Info.plist 隐私描述已配置，HKHealthStore 代码已集成 | ✅ 已配置 |
| iCloud (CloudKit) | Entitlements 已配置，Container 需在 Developer Portal 手动创建 | ✅ 代码已就绪 |
| In-App Purchase | Entitlements 已配置，StoreKitService.swift 已实现 StoreKit 2 | ✅ 代码已就绪 |
| Code Signing | Debug/Release 均已配置 CODE_SIGN_ENTITLEMENTS | ✅ 已配置 |

### 后端服务

| 服务 | 说明 | 状态 |
|------|------|------|
| GitHub Pages | 政策页面已部署至 asunnyboy861.github.io/RepTap | ✅ 已部署 |
| Support Page | https://asunnyboy861.github.io/RepTap/support.html | ✅ 已部署 |
| Privacy Policy | https://asunnyboy861.github.io/RepTap/privacy.html | ✅ 已部署 |
| Terms of Use | https://asunnyboy861.github.io/RepTap/terms.html | ✅ 已部署 |
| Landing Page | https://asunnyboy861.github.io/RepTap/ | ✅ 已部署 |

### 代码生成

| 模块 | 说明 | 状态 |
|------|------|------|
| 核心功能 | MVVM 架构，SwiftData 模型，所有功能模块已生成 | ✅ 已完成 |
| StoreKitService | StoreKit 2 集成，Product ID: com.zzoutuo.RepTap.pro | ✅ 已完成 |
| HealthKitService | HKHealthStore 授权 + 数据读写 | ✅ 已完成 |
| SettingsView | 政策页面链接、Pro 购买入口、Restore Purchases | ✅ 已完成 |
| ProPurchaseView | Pro 功能展示 + 购买流程 | ✅ 已完成 |
| OnboardingView | 初始引导流程 | ✅ 已完成 |
| 300+ Exercise DB | 内置运动数据库 JSON | ✅ 已完成 |
| QA 迭代 | 编译错误修复、iOS 17 兼容性 | ✅ 已完成 |

### 部署

| 项目 | 说明 | 状态 |
|------|------|------|
| GitHub 仓库 | 代码已推送至 github.com/asunnyboy861/RepTap | ✅ 已完成 |
| GitHub Pages | 政策页面已部署 | ✅ 已完成 |
| Landing Page | 已部署（App Store ID 为占位符） | ✅ 已完成 |
| App Store 元数据 | keytext.md 已生成验证 | ✅ 已完成 |
| 定价配置 | price.md 已生成 | ✅ 已完成 |

---

## 三、能力检测详情

> 以下为 PHASE 2 原始检测数据。"Auto-Configured Capabilities" 和 "Manual Configuration Required" 的内容已重组到上方 Section 一 和 Section 二 中。

### Analysis

Based on operation guide analysis, the following capabilities are required:
- "健康" / "HealthKit" / "health" → HealthKit
- "同步" / "iCloud" / "CloudKit" → iCloud
- "购买" / "Pro" / "premium" / "买断" → In-App Purchase
- "手表" / "Watch" / "watchOS" → Apple Watch (future target)
- "Live Activity" / "ActivityKit" → Live Activity (future target)

### No Configuration Needed

- Push Notifications (not required)
- Location Services (not required)
- Camera/Photo Library (not required)
- Siri (not required)
- Sign in with Apple (not required)
- Background Modes (not required for MVP)

### Verification

- Build succeeded after configuration: ✅
- All entitlements correct: ✅
