import SwiftUI

// MARK: - LoginView
struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @FocusState private var focusedField: Field?

    enum Field { case email, password }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    headerSection

                    // Form
                    formSection
                        .padding(.horizontal, 24)
                        .padding(.top, 40)

                    Spacer(minLength: 40)

                    // Footer
                    footerSection
                        .padding(.bottom, 32)
                }
            }
            .background(Color(.systemBackground))
        }
        .navigationViewStyle(.stack)
    }

    // MARK: Header
    private var headerSection: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(
                    colors: [Color.blue, Color.purple.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                VStack(spacing: 12) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    Text("Student Portal")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    Text("University of Excellence")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(.vertical, 50)
            }
        }
    }

    // MARK: Form
    private var formSection: some View {
        VStack(spacing: 20) {
            // Email
            VStack(alignment: .leading, spacing: 6) {
                Label("Email Address", systemImage: "envelope.fill")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)

                TextField("student@university.edu", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(focusedField == .email ? Color.blue : Color.clear, lineWidth: 2)
                    )
            }

            // Password
            VStack(alignment: .leading, spacing: 6) {
                Label("Password", systemImage: "lock.fill")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)

                HStack {
                    if showPassword {
                        TextField("Password", text: $password)
                            .focused($focusedField, equals: .password)
                    } else {
                        SecureField("Password", text: $password)
                            .focused($focusedField, equals: .password)
                    }
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(focusedField == .password ? Color.blue : Color.clear, lineWidth: 2)
                )
            }

            // Forgot Password
            HStack {
                Spacer()
                Button("Forgot Password?") {}
                    .font(.caption)
                    .foregroundColor(.blue)
            }

            // Error Message
            if let error = authViewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text(error)
                        .font(.caption)
                }
                .foregroundColor(.red)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }

            // Login Button
            Button {
                focusedField = nil
                Task { await authViewModel.login(email: email, password: password) }
            } label: {
                HStack {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Sign In")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(14)
            }
            .disabled(authViewModel.isLoading)

            // Demo hint
            VStack(spacing: 4) {
                Text("Demo credentials:")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text("student@university.edu / password123")
                    .font(.caption2)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        email = "student@university.edu"
                        password = "password123"
                    }
            }
            .padding(.top, 4)
        }
    }

    // MARK: Footer
    private var footerSection: some View {
        VStack(spacing: 8) {
            Divider()
            Text("© 2025 University of Excellence. All rights reserved.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
