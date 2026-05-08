import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> AuthResponse
    func register(request: RegistrationRequest) async throws -> AuthResponse
    func logout() async
    func checkSession() async -> User?
}

final class AuthService: AuthServiceProtocol {
    static let shared = AuthService()
    
    private let userDefaultsKey = "currentUser"
    private let tokenKey = "authToken"
    private let rememberMeKey = "rememberMe"
    private let emailKey = "savedEmail"
    
    private init() {}
    
    func login(email: String, password: String) async throws -> AuthResponse {
        try await Task.sleep(nanoseconds: 1_200_000_000)
        
        // Mock validation
        guard email.lowercased() == "student@olfu.edu.ph" || email.lowercased() == "juan.delacruz@olfu.edu.ph" else {
            throw APIError.unauthorized
        }
        
        guard password == "password123" else {
            throw APIError.unauthorized
        }
        
        let user = User.sample
        let token = "mock-jwt-token-\(UUID().uuidString)"
        
        saveUser(user)
        saveToken(token)
        
        return AuthResponse(
            success: true,
            message: "Login successful",
            token: token,
            user: user
        )
    }
    
    func register(request: RegistrationRequest) async throws -> AuthResponse {
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        guard !request.email.isEmpty, request.email.contains("@") else {
            throw APIError.validationError
        }
        
        guard request.password.count >= 8 else {
            throw APIError(code: 422, message: "Password must be at least 8 characters.")
        }
        
        let user = User(
            id: "USR-\(UUID().uuidString.prefix(8))",
            firstName: request.firstName,
            lastName: request.lastName,
            email: request.email,
            studentID: request.studentID,
            course: request.course,
            yearLevel: request.yearLevel,
            section: "1A",
            profileImageURL: nil,
            phoneNumber: nil,
            address: nil
        )
        
        let token = "mock-jwt-token-\(UUID().uuidString)"
        
        saveUser(user)
        saveToken(token)
        
        return AuthResponse(
            success: true,
            message: "Registration successful",
            token: token,
            user: user
        )
    }
    
    func logout() async {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    func checkSession() async -> User? {
        try? await Task.sleep(nanoseconds: 800_000_000)
        return loadUser()
    }
    
    // MARK: - Remember Me
    
    func setRememberMe(_ enabled: Bool, email: String) {
        UserDefaults.standard.set(enabled, forKey: rememberMeKey)
        if enabled {
            UserDefaults.standard.set(email, forKey: emailKey)
        } else {
            UserDefaults.standard.removeObject(forKey: emailKey)
        }
    }
    
    func isRememberMeEnabled() -> Bool {
        UserDefaults.standard.bool(forKey: rememberMeKey)
    }
    
    func getSavedEmail() -> String? {
        UserDefaults.standard.string(forKey: emailKey)
    }
    
    // MARK: - Persistence
    
    private func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func loadUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return nil }
        return try? JSONDecoder().decode(User.self, from: data)
    }
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
}
