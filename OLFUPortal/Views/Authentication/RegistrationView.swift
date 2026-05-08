import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    let courses = ["BSIT", "BSCS", "BSA", "BSBA", "BSN", "BSED", "BEED", "BSCPE", "BSECE"]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.paleGreen)
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 32))
                                .foregroundStyle(AppTheme.primaryGreen)
                        }
                        
                        Text("Create Account")
                            .font(.title2.bold())
                        
                        Text("Fill in your details to get started")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    .padding(.top, 8)
                    
                    VStack(spacing: 16) {
                        // Name fields
                        HStack(spacing: 12) {
                            formField(title: "First Name", icon: "person.fill", text: $authViewModel.regFirstName)
                            formField(title: "Last Name", icon: "person.fill", text: $authViewModel.regLastName)
                        }
                        
                        // Student ID
                        formField(title: "Student ID", icon: "number", text: $authViewModel.regStudentID, placeholder: "2024-00123")
                        
                        // Email
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email Address")
                                .font(.subheadline.bold())
                            
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .foregroundStyle(AppTheme.secondaryText)
                                    .frame(width: 20)
                                
                                TextField("student@olfu.edu.ph", text: $authViewModel.regEmail)
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                            }
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
                        }
                        
                        // Course picker
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Course")
                                .font(.subheadline.bold())
                            
                            HStack(spacing: 12) {
                                Image(systemName: "book.fill")
                                    .foregroundStyle(AppTheme.secondaryText)
                                    .frame(width: 20)
                                
                                Picker("Course", selection: $authViewModel.regCourse) {
                                    ForEach(courses, id: \.self) { course in
                                        Text(course).tag(course)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(AppTheme.darkText)
                                
                                Spacer()
                            }
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
                        }
                        
                        // Year level
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Year Level")
                                .font(.subheadline.bold())
                            
                            HStack(spacing: 12) {
                                Image(systemName: "graduationcap.fill")
                                    .foregroundStyle(AppTheme.secondaryText)
                                    .frame(width: 20)
                                
                                Picker("Year Level", selection: $authViewModel.regYearLevel) {
                                    ForEach(1...5, id: \.self) { year in
                                        Text("\(year)\(yearSuffix(year)) Year").tag(year)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(AppTheme.darkText)
                                
                                Spacer()
                            }
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.subheadline.bold())
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(AppTheme.secondaryText)
                                    .frame(width: 20)
                                
                                if isPasswordVisible {
                                    TextField("Minimum 8 characters", text: $authViewModel.regPassword)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Minimum 8 characters", text: $authViewModel.regPassword)
                                }
                                
                                Button { isPasswordVisible.toggle() } label: {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundStyle(AppTheme.secondaryText)
                                }
                            }
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
                        }
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Confirm Password")
                                .font(.subheadline.bold())
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(AppTheme.secondaryText)
                                    .frame(width: 20)
                                
                                if isConfirmPasswordVisible {
                                    TextField("Re-enter password", text: $authViewModel.regConfirmPassword)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Re-enter password", text: $authViewModel.regConfirmPassword)
                                }
                                
                                Button { isConfirmPasswordVisible.toggle() } label: {
                                    Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundStyle(AppTheme.secondaryText)
                                }
                            }
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
                            
                            if !authViewModel.regConfirmPassword.isEmpty && !Validators.passwordsMatch(authViewModel.regPassword, authViewModel.regConfirmPassword) {
                                Text("Passwords do not match")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.error)
                            }
                        }
                    }
                    
                    GreenButton(
                        title: "Create Account",
                        isLoading: authViewModel.isLoading,
                        isDisabled: !authViewModel.isRegistrationValid
                    ) {
                        Task {
                            await authViewModel.register()
                            if authViewModel.isAuthenticated {
                                dismiss()
                            }
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondaryText)
                        
                        Button("Sign In") {
                            dismiss()
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(AppTheme.primaryGreen)
                    }
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.subheadline.bold())
                            .foregroundStyle(AppTheme.darkText)
                    }
                }
            }
            .alert("Registration Failed", isPresented: $authViewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authViewModel.errorMessage ?? "An error occurred")
            }
        }
    }
    
    private func formField(title: String, icon: String, text: Binding<String>, placeholder: String = "") -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.bold())
            
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(AppTheme.secondaryText)
                    .frame(width: 20)
                
                TextField(placeholder.isEmpty ? title : placeholder, text: text)
                    .autocorrectionDisabled()
            }
            .padding(14)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
        }
    }
    
    private func yearSuffix(_ year: Int) -> String {
        switch year {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
}
