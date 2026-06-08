import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var settingsVM = SettingsViewModel()
    @State private var storeKitService = StoreKitService()
    @State private var showProPaywall = false
    @State private var showExport = false
    @State private var showContact = false

    private let githubUser = "asunnyboy861"
    private let appName = "RepTap"

    var body: some View {
        NavigationStack {
            Form {
                workoutSection
                proSection
                dataSection
                legalSection
                aboutSection
            }
            .navigationTitle("Settings")
            .onAppear {
                settingsVM.loadSettings()
                storeKitService.checkProStatus()
            }
        }
    }

    private var workoutSection: some View {
        Section("Workout") {
            Stepper("Rest Timer: \(settingsVM.defaultRestSeconds)s", value: $settingsVM.defaultRestSeconds, in: 15...300, step: 15)
                .onChange(of: settingsVM.defaultRestSeconds) { _, newValue in
                    settingsVM.saveDefaultRest(newValue)
                }

            Picker("Weight Unit", selection: $settingsVM.weightUnit) {
                ForEach(SettingsViewModel.WeightUnit.allCases, id: \.self) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .onChange(of: settingsVM.weightUnit) { _, newValue in
                settingsVM.saveWeightUnit(newValue)
            }

            Toggle("iCloud Sync", isOn: $settingsVM.iCloudSyncEnabled)
                .onChange(of: settingsVM.iCloudSyncEnabled) { _, newValue in
                    settingsVM.saveiCloudSync(newValue)
                }
        }
    }

    private var proSection: some View {
        Section("Pro") {
            if storeKitService.isPro {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(Color.appProGold)
                    Text("Pro Unlocked")
                        .font(.subheadline.bold())
                }
            } else {
                Button {
                    showProPaywall = true
                } label: {
                    HStack {
                        Image(systemName: "crown")
                            .foregroundStyle(Color.appProGold)
                        Text("Upgrade to Pro")
                            .font(.subheadline.bold())
                        Spacer()
                        Text("$14.99")
                            .font(.caption)
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }
            }

            Button("Restore Purchases") {
                Task { await storeKitService.restorePurchases() }
            }
        }
        .sheet(isPresented: $showProPaywall) {
            ProPurchaseView(storeKitService: storeKitService)
        }
    }

    private var dataSection: some View {
        Section("Data") {
            Button {
                showExport = true
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Export Data")
                }
            }
            .sheet(isPresented: $showExport) {
                DataExportView()
            }
        }
    }

    private var legalSection: some View {
        Section("Legal") {
            Link("Privacy Policy", destination: URL(string: "https://\(githubUser).github.io/\(appName)/privacy.html")!)
            Link("Terms of Use", destination: URL(string: "https://\(githubUser).github.io/\(appName)/terms.html")!)
            Link("Support", destination: URL(string: "https://\(githubUser).github.io/\(appName)/support.html")!)

            Button {
                showContact = true
            } label: {
                HStack {
                    Image(systemName: "envelope")
                    Text("Contact Support")
                }
            }
            .sheet(isPresented: $showContact) {
                ContactSupportView()
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
    }
}
