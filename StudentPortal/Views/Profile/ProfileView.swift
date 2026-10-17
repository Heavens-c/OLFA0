import SwiftUI

// MARK: - ProfileView
struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogoutAlert = false

    var student: Student? { authViewModel.currentStudent }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Avatar & Name
                avatarSection

                // Info Cards
                if let student = student {
                    infoCard(title: "Student Information", items: [
                        ("person.fill", "Full Name", student.fullName),
                        ("number", "Student ID", student.studentID),
                        ("envelope.fill", "Email", student.email),
                        ("graduationcap.fill", "Major", student.major),
                        ("calendar", "Year", student.displayYear)
                    ])

                    infoCard(title: "Academic Summary", items: [
                        ("chart.bar.fill", "Cumulative GPA", String(format: "%.2f / 4.00", student.gpa)),
                        ("book.fill", "Credit Status", "80 earned / 120 required"),
                        ("clock.fill", "Expected Graduation", "May 2026")
                    ])
                }

                // Quick Links
                quickLinksSection

                // Logout
                Button(role: .destructive) {
                    showLogoutAlert = true
                } label: {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .alert("Sign Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Sign Out", role: .destructive) { authViewModel.logout() }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }

    // MARK: Avatar
    private var avatarSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)

                Text(initials)
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.top, 20)

            Text(student?.fullName ?? "Student")
                .font(.title2.bold())

            Text(student?.email ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
                Text("GPA \(String(format: "%.2f", student?.gpa ?? 0.0))")
                    .font(.subheadline.bold())
                    .foregroundColor(.green)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var initials: String {
        guard let student = student else { return "?" }
        let f = student.firstName.prefix(1)
        let l = student.lastName.prefix(1)
        return "\(f)\(l)"
    }

    // MARK: Info Card
    private func infoCard(title: String, items: [(String, String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { i, item in
                    HStack(spacing: 12) {
                        Image(systemName: item.0)
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        Text(item.1)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(item.2)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if i < items.count - 1 {
                        Divider().padding(.leading, 48)
                    }
                }
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }

    // MARK: Quick Links
    private var quickLinksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Resources")
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 0) {
                quickLinkRow(icon: "doc.text.fill", iconColor: .blue, title: "Academic Transcript")
                Divider().padding(.leading, 48)
                quickLinkRow(icon: "dollarsign.circle.fill", iconColor: .green, title: "Financial Aid")
                Divider().padding(.leading, 48)
                quickLinkRow(icon: "calendar.badge.plus", iconColor: .purple, title: "Course Registration")
                Divider().padding(.leading, 48)
                quickLinkRow(icon: "envelope.fill", iconColor: .orange, title: "Contact Advisor")
                Divider().padding(.leading, 48)
                quickLinkRow(icon: "questionmark.circle.fill", iconColor: .gray, title: "Help & Support")
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }

    private func quickLinkRow(icon: String, iconColor: Color, title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 20)
            Text(title)
                .font(.subheadline)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
