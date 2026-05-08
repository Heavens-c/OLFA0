import Foundation
import Combine
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isCheckingSession = true
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var prefersDarkMode = false
    
    // Login fields
    @Published var loginEmail = ""
    @Published var loginPassword = ""
    @Published var rememberMe = false
    
    // Registration fields
    @Published var regFirstName = ""
    @Published var regLastName = ""
    @Published var regEmail = ""
    @Published var regPassword = ""
    @Published var regConfirmPassword = ""
    @Published var regStudentID = ""
    @Published var regCourse = "BSIT"
    @Published var regYearLevel = 1
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
        
        // Load remember me state
        let service = authService as? AuthService
        rememberMe = service?.isRememberMeEnabled() ?? false
        if rememberMe, let savedEmail = service?.getSavedEmail() {
            loginEmail = savedEmail
        }
        
        // Load dark mode preference
        prefersDarkMode = UserDefaults.standard.bool(forKey: "prefersDarkMode")
        
        Task {
            await checkSession()
        }
    }
    
    // MARK: - Validation
    
    var isLoginValid: Bool {
        Validators.isValidEmail(loginEmail) && Validators.isValidPassword(loginPassword)
    }
    
    var isRegistrationValid: Bool {
        Validators.isNotEmpty(regFirstName) &&
        Validators.isNotEmpty(regLastName) &&
        Validators.isValidEmail(regEmail) &&
        Validators.isValidPassword(regPassword) &&
        Validators.passwordsMatch(regPassword, regConfirmPassword) &&
        Validators.isNotEmpty(regStudentID)
    }
    
    var loginEmailError: String? {
        if loginEmail.isEmpty { return nil }
        return Validators.isValidEmail(loginEmail) ? nil : "Please enter a valid email address"
    }
    
    var loginPasswordError: String? {
        if loginPassword.isEmpty { return nil }
        return Validators.isValidPassword(loginPassword) ? nil : "Password must be at least 8 characters"
    }
    
    // MARK: - Actions
    
    func login() async {
        guard isLoginValid else {
            showErrorMessage("Please fill in all fields correctly.")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.login(email: loginEmail, password: loginPassword)
            currentUser = response.user
            isAuthenticated = true
            
            if let service = authService as? AuthService {
                service.setRememberMe(rememberMe, email: loginEmail)
            }
            
            if !rememberMe {
                loginEmail = ""
            }
            loginPassword = ""
        } catch let error as APIError {
            showErrorMessage(error.message)
        } catch {
            showErrorMessage("An unexpected error occurred. Please try again.")
        }
        
        isLoading = false
    }
    
    func register() async {
        guard isRegistrationValid else {
            showErrorMessage("Please fill in all fields correctly.")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let request = RegistrationRequest(
            firstName: regFirstName,
            lastName: regLastName,
            email: regEmail,
            password: regPassword,
            studentID: regStudentID,
            course: regCourse,
            yearLevel: regYearLevel
        )
        
        do {
            let response = try await authService.register(request: request)
            currentUser = response.user
            isAuthenticated = true
            clearRegistrationFields()
        } catch let error as APIError {
            showErrorMessage(error.message)
        } catch {
            showErrorMessage("An unexpected error occurred. Please try again.")
        }
        
        isLoading = false
    }
    
    func logout() async {
        isLoading = true
        await authService.logout()
        currentUser = nil
        isAuthenticated = false
        loginPassword = ""
        isLoading = false
    }
    
    func toggleDarkMode() {
        prefersDarkMode.toggle()
        UserDefaults.standard.set(prefersDarkMode, forKey: "prefersDarkMode")
    }
    
    func updateProfile(firstName: String, lastName: String, phone: String?, address: String?) {
        currentUser?.firstName = firstName
        currentUser?.lastName = lastName
        currentUser?.phoneNumber = phone
        currentUser?.address = address
        
        if let user = currentUser, let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: "currentUser")
        }
    }
    
    // MARK: - Private
    
    private func checkSession() async {
        if let user = await authService.checkSession() {
            currentUser = user
            isAuthenticated = true
        }
        isCheckingSession = false
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    private func clearRegistrationFields() {
        regFirstName = ""
        regLastName = ""
        regEmail = ""
        regPassword = ""
        regConfirmPassword = ""
        regStudentID = ""
        regCourse = "BSIT"
        regYearLevel = 1
    }
}
