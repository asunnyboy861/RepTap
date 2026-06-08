import SwiftUI

struct ContactSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSubject = "General"
    @State private var customSubject = ""
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false

    private let subjects = ["General", "Feature Suggestion", "Bug Report", "Usage Question", "Performance Issue", "UI Improvement", "Other"]
    private let backendURL = "https://feedback-board.iocompile67692.workers.dev"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    subjectSection
                    if selectedSubject == "Other" {
                        customSubjectField
                    }
                    nameField
                    emailField
                    messageField
                    submitButton
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
            .alert("Sent!", isPresented: $showSuccess) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your feedback has been submitted. We'll get back to you soon!")
            }
        }
    }

    private var subjectSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Subject")
                .font(.subheadline.bold())
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                ForEach(subjects, id: \.self) { subject in
                    Button {
                        selectedSubject = subject
                    } label: {
                        Text(subject)
                            .font(.caption.bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(minWidth: 100)
                            .background(selectedSubject == subject ? Color.appOrange : Color.appCard, in: RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(selectedSubject == subject ? .white : Color.appTextPrimary)
                    }
                }
            }
        }
    }

    private var customSubjectField: some View {
        TextField("Enter your subject", text: $customSubject)
            .textFieldStyle(.roundedBorder)
    }

    private var nameField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Name")
                .font(.subheadline.bold())
            TextField("Your name", text: $name)
                .textFieldStyle(.roundedBorder)
        }
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Email")
                .font(.subheadline.bold())
            TextField("your@email.com", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
        }
    }

    private var messageField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Message")
                .font(.subheadline.bold())
            TextEditor(text: $message)
                .frame(minHeight: 120)
                .padding(4)
                .background(Color.appCard, in: RoundedRectangle(cornerRadius: 8))
        }
    }

    private var submitButton: some View {
        Button {
            submitFeedback()
        } label: {
            if isSubmitting {
                ProgressView()
                    .tint(.white)
            } else {
                Text("Submit")
                    .font(.headline)
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(name.isEmpty || email.isEmpty || message.isEmpty ? Color.gray : Color.appOrange, in: RoundedRectangle(cornerRadius: 12))
        .disabled(name.isEmpty || email.isEmpty || message.isEmpty || isSubmitting)
    }

    private func submitFeedback() {
        isSubmitting = true
        let subjectValue = selectedSubject == "Other" ? customSubject : selectedSubject

        let request = FeedbackRequest(
            name: name,
            email: email,
            subject: subjectValue,
            message: message,
            app_name: "RepTap"
        )

        guard let url = URL(string: "\(backendURL)/api/feedback"),
              let body = try? JSONEncoder().encode(request) else {
            errorMessage = "Failed to prepare request"
            showError = true
            isSubmitting = false
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            Task { @MainActor in
                isSubmitting = false
                if let error = error {
                    errorMessage = error.localizedDescription
                    showError = true
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    showSuccess = true
                } else {
                    errorMessage = "Server error. Please try again."
                    showError = true
                }
            }
        }.resume()
    }
}

struct FeedbackRequest: Codable {
    let name: String
    let email: String
    let subject: String
    let message: String
    let app_name: String
}
