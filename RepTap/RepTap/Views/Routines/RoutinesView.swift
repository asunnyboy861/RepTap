import SwiftUI
import SwiftData

struct RoutinesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutTemplate.lastUsedAt, order: .reverse)
    private var templates: [WorkoutTemplate]
    @State private var showEditor = false
    @State private var editingTemplate: WorkoutTemplate?

    var body: some View {
        NavigationStack {
            List {
                ForEach(templates) { template in
                    RoutineRow(template: template)
                        .onTapGesture {
                            editingTemplate = template
                            showEditor = true
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                modelContext.delete(template)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Routines")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        editingTemplate = nil
                        showEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showEditor) {
                RoutineEditorView(template: editingTemplate)
            }
            .overlay {
                if templates.isEmpty {
                    ContentUnavailableView(
                        "No Routines Yet",
                        systemImage: "list.bullet.clipboard",
                        description: Text("Create a routine to quickly start workouts with your favorite exercises.")
                    )
                }
            }
        }
    }
}

struct RoutineRow: View {
    let template: WorkoutTemplate

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(template.name)
                .font(.subheadline.bold())
            HStack {
                Text("\(template.exercises.count) exercises")
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
                if let lastUsed = template.lastUsedAt {
                    Text("Last: \(lastUsed.formattedDateOnly)")
                        .font(.caption)
                        .foregroundStyle(Color.appTextSecondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct RoutineEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let template: WorkoutTemplate?
    @State private var name = ""
    @State private var exercises: [TemplateExerciseItem] = []
    @State private var showExercisePicker = false

    struct TemplateExerciseItem: Identifiable {
        let id = UUID()
        var exercise: Exercise?
        var targetSets: Int = 3
        var targetReps: Int = 10
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Routine Name") {
                    TextField("e.g. Push Day", text: $name)
                }

                Section("Exercises") {
                    ForEach($exercises) { $item in
                        HStack {
                            Text(item.exercise?.name ?? "Select Exercise")
                                .font(.subheadline)
                            Spacer()
                            Stepper("\(item.targetSets)x\(item.targetReps)", onIncrement: {
                                item.targetSets += 1
                            }, onDecrement: {
                                item.targetSets = max(1, item.targetSets - 1)
                            })
                        }
                    }
                    .onDelete { indexSet in
                        exercises.remove(atOffsets: indexSet)
                    }

                    Button("Add Exercise") {
                        showExercisePicker = true
                    }
                }
            }
            .navigationTitle(template == nil ? "New Routine" : "Edit Routine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTemplate()
                        dismiss()
                    }
                    .disabled(name.isEmpty || exercises.isEmpty)
                }
            }
            .sheet(isPresented: $showExercisePicker) {
                ExercisePickerView { exercise in
                    exercises.append(TemplateExerciseItem(exercise: exercise))
                }
            }
            .onAppear {
                if let template = template {
                    name = template.name
                    exercises = template.exercises.map { te in
                        TemplateExerciseItem(exercise: te.exercise, targetSets: te.targetSets, targetReps: te.targetReps)
                    }
                }
            }
        }
    }

    private func saveTemplate() {
        let template = self.template ?? WorkoutTemplate(name: name)
        template.name = name
        for old in template.exercises {
            modelContext.delete(old)
        }
        template.exercises.removeAll()
        for (index, item) in exercises.enumerated() {
            let te = TemplateExercise(targetSets: item.targetSets, targetReps: item.targetReps, sortOrder: index)
            te.exercise = item.exercise
            te.template = template
            template.exercises.append(te)
        }
        if self.template == nil {
            modelContext.insert(template)
        }
    }
}
