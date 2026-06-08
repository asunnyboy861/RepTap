import SwiftUI
import SwiftData

struct ExercisePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let onSelect: (Exercise) -> Void
    @State private var exerciseVM = ExerciseViewModel()
    @State private var showCreateCustom = false
    @State private var customName = ""
    @State private var customMuscleGroup = MuscleGroup.chest
    @State private var customEquipment = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                muscleGroupFilter
                exerciseList
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Custom") { showCreateCustom = true }
                }
            }
            .searchable(text: $exerciseVM.searchText, prompt: "Search exercises")
            .onAppear {
                exerciseVM.loadExercises(modelContext: modelContext)
            }
            .alert("Create Custom Exercise", isPresented: $showCreateCustom) {
                TextField("Name", text: $customName)
                Button("Create") {
                    exerciseVM.createCustomExercise(
                        name: customName,
                        muscleGroup: customMuscleGroup.rawValue,
                        equipment: customEquipment,
                        modelContext: modelContext
                    )
                    customName = ""
                    customEquipment = ""
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter exercise details")
            }
        }
    }

    private var muscleGroupFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "All", isSelected: exerciseVM.selectedMuscleGroup == nil) {
                    exerciseVM.selectedMuscleGroup = nil
                }
                ForEach(MuscleGroup.allCases, id: \.self) { group in
                    FilterChip(label: group.rawValue, isSelected: exerciseVM.selectedMuscleGroup == group) {
                        exerciseVM.selectedMuscleGroup = group
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }

    private var exerciseList: some View {
        List(exerciseVM.filteredExercises) { exercise in
            Button {
                onSelect(exercise)
                dismiss()
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(exercise.name)
                            .font(.subheadline)
                        Text(exercise.muscleGroup)
                            .font(.caption)
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    Spacer()
                    if exercise.isCustom {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundStyle(Color.appProGold)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.appOrange : Color.appCard, in: Capsule())
                .foregroundStyle(isSelected ? .white : Color.appTextPrimary)
        }
    }
}
