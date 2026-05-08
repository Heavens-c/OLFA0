import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var address = ""
    @State private var showSaved = false

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    ZStack(alignment: .bottomTrailing) {
                        ProfileAvatar(name: "\(firstName) \(lastName)", size: 80)
                        Circle().fill(AppTheme.primaryGreen).frame(width: 28, height: 28)
                            .overlay(Image(systemName: "camera.fill").font(.caption2).foregroundStyle(.white))
                    }
                    .frame(maxWidth: .infinity).padding(.top, 8)

                    VStack(spacing: 16) {
                        field("First Name", "person.fill", $firstName)
                        field("Last Name", "person.fill", $lastName)
                        field("Phone", "phone.fill", $phoneNumber)
                        field("Address", "mappin", $address)
                    }
                }
                .padding()
            }
            .background(AppTheme.Adaptive.background(colorScheme))
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundStyle(AppTheme.secondaryText)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        authViewModel.updateProfile(firstName: firstName, lastName: lastName,
                            phone: phoneNumber.isEmpty ? nil : phoneNumber,
                            address: address.isEmpty ? nil : address)
                        showSaved = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { dismiss() }
                    }
                    .font(.headline).foregroundStyle(AppTheme.primaryGreen)
                }
            }
            .onAppear {
                if let u = authViewModel.currentUser {
                    firstName = u.firstName; lastName = u.lastName
                    phoneNumber = u.phoneNumber ?? ""; address = u.address ?? ""
                }
            }
        }
    }

    private func field(_ title: String, _ icon: String, _ text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.subheadline.bold())
            HStack(spacing: 12) {
                Image(systemName: icon).foregroundStyle(AppTheme.secondaryText).frame(width: 20)
                TextField(title, text: text)
            }
            .padding(14).background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
        }
    }
}
