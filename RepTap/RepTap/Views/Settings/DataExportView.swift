import SwiftUI
import SwiftData

struct DataExportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var exportedFile: Data?
    @State private var fileName = ""
    @State private var showShareSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.appOrange)

                Text("Export Your Data")
                    .font(.title2.bold())

                Text("Choose a format to export your complete workout history.")
                    .font(.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    Button {
                        if let csv = BackupService.exportCSV(modelContext: modelContext) {
                            exportedFile = Data(csv.utf8)
                            fileName = "RepTap_Export_\(formatDate()).csv"
                            showShareSheet = true
                        }
                    } label: {
                        ExportFormatRow(icon: "doc.text", title: "CSV", subtitle: "Spreadsheet compatible")
                    }

                    Button {
                        if let json = BackupService.exportJSON(modelContext: modelContext) {
                            exportedFile = json
                            fileName = "RepTap_Export_\(formatDate()).json"
                            showShareSheet = true
                        }
                    } label: {
                        ExportFormatRow(icon: "curlybraces", title: "JSON", subtitle: "Developer friendly")
                    }
                }
            }
            .padding()
            .background(Color.appBackground)
            .navigationTitle("Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let data = exportedFile {
                    ShareSheet(items: [data], fileName: fileName)
                }
            }
        }
    }

    private func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: .now)
    }
}

struct ExportFormatRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.appOrange)
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(Color.appTextSecondary)
        }
        .padding()
        .background(Color.appCard, in: RoundedRectangle(cornerRadius: 10))
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    var fileName: String = ""

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
