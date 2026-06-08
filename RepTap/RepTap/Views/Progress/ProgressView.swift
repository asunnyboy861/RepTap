import SwiftUI
import SwiftData
import Charts

struct ProgressDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ProgressViewModel()
    @State private var storeKitService = StoreKitService()
    @State private var showProPaywall = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    timeRangePicker
                    volumeChart
                    prListSection
                    muscleHeatmapSection
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Progress")
        }
        .onAppear {
            viewModel.loadData(modelContext: modelContext)
        }
    }

    private var timeRangePicker: some View {
        Picker("Time Range", selection: $viewModel.selectedTimeRange) {
            ForEach(ProgressViewModel.TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
    }

    private var volumeChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Volume Trend")
                .font(.headline)

            if viewModel.weeklyVolumeData.isEmpty {
                Text("Complete workouts to see your progress")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
            } else {
                Chart(viewModel.weeklyVolumeData) { data in
                    BarMark(
                        x: .value("Week", data.weekStart, unit: .weekOfYear),
                        y: .value("Volume", data.totalVolume)
                    )
                    .foregroundStyle(Color.appOrange.gradient)
                }
                .frame(height: 200)
                .chartYAxisLabel("Volume")
            }
        }
        .padding()
        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 12))
    }

    private var prListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Personal Records")
                .font(.headline)

            if viewModel.personalRecords.isEmpty {
                Text("Log workouts to track your PRs")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
            } else {
                ForEach(viewModel.personalRecords.prefix(10)) { pr in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(pr.exerciseName)
                                .font(.subheadline.bold())
                            Text(pr.recordType)
                                .font(.caption)
                                .foregroundStyle(Color.appTextSecondary)
                        }
                        Spacer()
                        Text(pr.value.formattedWeight)
                            .font(.subheadline.bold())
                            .foregroundStyle(Color.appOrange)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 12))
    }

    private var muscleHeatmapSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Muscle Group Distribution")
                    .font(.headline)
                if !storeKitService.isPro {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(Color.appProGold)
                }
            }

            if storeKitService.isPro {
                if viewModel.muscleGroupDistribution.isEmpty {
                    Text("Complete workouts to see distribution")
                        .font(.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                } else {
                    Chart(viewModel.muscleGroupDistribution) { data in
                        SectorMark(
                            angle: .value("Volume", data.volume),
                            innerRadius: .ratio(0.5),
                            angularInset: 2
                        )
                        .foregroundStyle(Color.appOrange.opacity(Double(viewModel.muscleGroupDistribution.firstIndex(where: { $0.id == data.id }) ?? 0 + 1) / Double(viewModel.muscleGroupDistribution.count) * 0.8 + 0.2))
                        .annotation(position: .overlay) {
                            Text(data.muscleGroup)
                                .font(.caption2)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 200)
                }
            } else {
                Button {
                    showProPaywall = true
                } label: {
                    Text("Unlock with Pro")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color.appProGold)
                }
            }
        }
        .padding()
        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 12))
        .sheet(isPresented: $showProPaywall) {
            ProPurchaseView(storeKitService: storeKitService)
        }
    }
}
