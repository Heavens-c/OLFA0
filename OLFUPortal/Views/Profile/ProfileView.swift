import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showEditProfile = false
    @State private var showChangePassword = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    profileHeader
                    studentInfoSection
                    settingsSection
                    accountSection
                }
                .padding()
            }
            .background(AppTheme.Adaptive.background(colorScheme))
            .navigationTitle("Profile")
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
                    .environmentObject(authViewModel)
            }
            .sheet(isPresented: $showChangePassword) {
                ChangePasswordView()
            }
            .alert("Sign Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    Task { await authViewModel.logout() }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
    
    // MARK: - Profile Header
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                ProfileAvatar(
                    name: authViewModel.currentUser?.fullName ?? "Student",
                    size: 90
                )
                
                Circle()
                    .fill(AppTheme.primaryGreen)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.caption2)
                            .foregroundStyle(.white)
                    )
                    .offset(x: 4, y: 4)
            }
            
            VStack(spacing: 4) {
                Text(authViewModel.currentUser?.fullName ?? "Student")
                    .font(.title2.bold())
                
                Text(authViewModel.currentUser?.email ?? "")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
                
                if let user = authViewModel.currentUser {
                    Text(user.courseAndYear)
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.primaryGreen)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(AppTheme.paleGreen)
                        .clipShape(Capsule())
                        .padding(.top, 4)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(AppTheme.Adaptive.cardBackground(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusXL))
        .shadow(color: AppTheme.cardShadow, radius: 8, y: 4)
    }
    
    // MARK: - Student Info
    
    private var studentInfoSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "person.text.rectangle.fill")
                    .foregroundStyle(AppTheme.primaryGreen)
                Text("Student Information")
                    .font(.headline)
            }
            
            if let user = authViewModel.currentUser {
                InfoRow(icon: "number", label: "Student ID", value: user.studentID)
                InfoRow(icon: "book.fill", label: "Course", value: user.course)
                InfoRow(icon: "graduationcap.fill", label: "Year Level", value: user.yearLevelString)
                InfoRow(icon: "person.2.fill", label: "Section", value: user.section)
                
                if let phone = user.phoneNumber {
                    InfoRow(icon: "phone.fill", label: "Phone", value: phone)
                }
                
                if let address = user.address {
                    InfoRow(icon: "mappin.and.ellipse", label: "Address", value: address)
                }
            }
        }
        .padding()
        .background(AppTheme.Adaptive.cardBackground(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge))
        .shadow(color: AppTheme.cardShadow, radius: 6, y: 3)
    }
    
    // MARK: - Settings
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(AppTheme.primaryGreen)
                Text("Settings")
                    .font(.headline)
            }
            
            // Dark mode toggle
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AppTheme.accentPurple.opacity(0.12))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: authViewModel.prefersDarkMode ? "moon.fill" : "sun.max.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppTheme.accentPurple)
                }
                
                Text("Dark Mode")
                    .font(.subheadline)
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { authViewModel.prefersDarkMode },
                    set: { _ in authViewModel.toggleDarkMode() }
                ))
                .tint(AppTheme.primaryGreen)
            }
            
            Divider()
            
            // Edit profile
            Button {
                showEditProfile = true
            } label: {
                ProfileMenuRow(icon: "pencil", label: "Edit Profile", color: AppTheme.accentBlue)
            }
            
            Divider()
            
            // Change password
            Button {
                showChangePassword = true
            } label: {
                ProfileMenuRow(icon: "lock.rotation", label: "Change Password", color: AppTheme.accentOrange)
            }
        }
        .padding()
        .background(AppTheme.Adaptive.cardBackground(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge))
        .shadow(color: AppTheme.cardShadow, radius: 6, y: 3)
    }
    
    // MARK: - Account
    
    private var accountSection: some View {
        VStack(spacing: 14) {
            Button {
                showLogoutAlert = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Sign Out")
                        .font(.headline)
                    
                    Spacer()
                }
                .foregroundStyle(AppTheme.error)
                .padding()
                .background(AppTheme.error.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
            }
            
            Text("OLFU Portal v1.0.0")
                .font(.caption)
                .foregroundStyle(AppTheme.lightText)
                .padding(.top, 8)
        }
    }
}

// MARK: - Info Row

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(AppTheme.secondaryText)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(AppTheme.lightText)
                
                Text(value)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
}

// MARK: - Profile Menu Row

struct ProfileMenuRow: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(color)
            }
            
            Text(label)
                .font(.subheadline)
                .foregroundStyle(AppTheme.darkText)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(AppTheme.lightText)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
