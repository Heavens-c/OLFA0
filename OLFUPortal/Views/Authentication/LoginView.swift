import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showRegistration = false
    @State private var logoScale: CGFloat = 0.5
    @State private var formOpacity: Double = 0
    @State private var isPasswordVisible = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                headerSection
                formSection
            }
        }
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showRegistration) {
            RegistrationView()
                .environmentObject(authViewModel)
        }
        .alert("Login Failed", isPresented: $authViewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authViewModel.errorMessage ?? "An error occurred")
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                logoScale = 1.0
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                formOpacity = 1.0
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        ZStack {
            AppTheme.primaryGradient
                .frame(height: 320)
            
            // Decorative circles
            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 200, height: 200)
                .offset(x: -100, y: -60)
            
            Circle()
                .fill(.white.opacity(0.08))
                .frame(width: 150, height: 150)
                .offset(x: 120, y: 40)
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.white)
                }
                .scaleEffect(logoScale)
                
                VStack(spacing: 6) {
                    Text("OLFU Portal")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Sign in to your account")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                }
            }
            .padding(.top, 40)
        }
        .clipShape(
            RoundedShape(corners: [.bottomLeft, .bottomRight], radius: 30)
        )
    }
    
    // MARK: - Form
    
    private var formSection: some View {
        VStack(spacing: 20) {
            // Demo credentials hint
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(AppTheme.info)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Demo Credentials")
                        .font(.caption.bold())
                    Text("student@olfu.edu.ph / password123")
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondaryText)
                }
                Spacer()
            }
            .padding(12)
            .background(AppTheme.info.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
            
            // Email field
            VStack(alignment: .leading, spacing: 6) {
                Text("Email Address")
                    .font(.subheadline.bold())
                    .foregroundStyle(AppTheme.darkText)
                
                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(AppTheme.secondaryText)
                        .frame(width: 20)
                    
                    TextField("Enter your email", text: $authViewModel.loginEmail)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                .padding(14)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
                
                if let error = authViewModel.loginEmailError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(AppTheme.error)
                }
            }
            
            // Password field
            VStack(alignment: .leading, spacing: 6) {
                Text("Password")
                    .font(.subheadline.bold())
                    .foregroundStyle(AppTheme.darkText)
                
                HStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(AppTheme.secondaryText)
                        .frame(width: 20)
                    
                    if isPasswordVisible {
                        TextField("Enter your password", text: $authViewModel.loginPassword)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    } else {
                        SecureField("Enter your password", text: $authViewModel.loginPassword)
                    }
                    
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
                .padding(14)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
                
                if let error = authViewModel.loginPasswordError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(AppTheme.error)
                }
            }
            
            // Remember me
            HStack {
                Toggle(isOn: $authViewModel.rememberMe) {
                    Text("Remember me")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                }
                .tint(AppTheme.primaryGreen)
                .toggleStyle(.switch)
                .scaleEffect(0.85, anchor: .leading)
            }
            
            // Login button
            GreenButton(
                title: "Sign In",
                isLoading: authViewModel.isLoading,
                isDisabled: !authViewModel.isLoginValid
            ) {
                Task { await authViewModel.login() }
            }
            .padding(.top, 8)
            
            // Register link
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
                
                Button("Sign Up") {
                    showRegistration = true
                }
                .font(.subheadline.bold())
                .foregroundStyle(AppTheme.primaryGreen)
            }
            .padding(.top, 8)
            
            // Version
            Text("Version 1.0.0")
                .font(.caption2)
                .foregroundStyle(AppTheme.lightText)
                .padding(.top, 20)
        }
        .padding(24)
        .padding(.top, 8)
        .opacity(formOpacity)
    }
}

// MARK: - Rounded Shape Helper

struct RoundedShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
