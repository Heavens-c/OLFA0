import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showSuccess = false
    @State private var errorMessage: String?

    var isValid: Bool {
        currentPassword.count >= 8 && newPassword.count >= 8 &&
        newPassword == confirmPassword && newPassword != currentPassword
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ZStack {
                        Circle().fill(AppTheme.paleGreen).frame(width: 70, height: 70)
                        Image(systemName: "lock.rotation").font(.system(size: 28)).foregroundStyle(AppTheme.primaryGreen)
                    }.padding(.top, 8)

                    passwordField("Current Password", $currentPassword)
                    passwordField("New Password", $newPassword)
                    passwordField("Confirm New Password", $confirmPassword)

                    if !confirmPassword.isEmpty && newPassword != confirmPassword {
                        Text("Passwords do not match")
                            .font(.caption).foregroundStyle(AppTheme.error)
                    }

                    if let error = errorMessage {
                        Text(error).font(.caption).foregroundStyle(AppTheme.error)
                    }

                    GreenButton(title: "Update Password", isDisabled: !isValid) {
                        showSuccess = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { dismiss() }
                    }.padding(.top, 8)
                }
                .padding()
            }
            .background(AppTheme.Adaptive.background(colorScheme))
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundStyle(AppTheme.secondaryText)
                }
            }
            .overlay {
                if showSuccess {
                    VStack { Spacer()
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Password updated")
                        }
                        .font(.subheadline.bold()).foregroundStyle(.white)
                        .padding().background(AppTheme.success).clipShape(Capsule())
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }

    private func passwordField(_ title: String, _ text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.subheadline.bold())
            HStack(spacing: 12) {
                Image(systemName: "lock.fill").foregroundStyle(AppTheme.secondaryText).frame(width: 20)
                SecureField(title, text: text)
            }
            .padding(14).background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
        }
    }
}
