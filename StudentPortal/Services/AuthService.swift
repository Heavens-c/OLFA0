import Foundation
import Combine

// MARK: - AuthService
class AuthService {
    static let shared = AuthService()
    private init() {}

    private let tokenKey = "auth_token"
    private let studentKey = "current_student"

    // Simulates a network login request
    func login(email: String, password: String) async throws -> Student {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Demo credential validation
        guard email.lowercased() == "student@university.edu" && password == "password123" else {
            throw AuthError.invalidCredentials
        }

        let student = Student(
            id: "STU-001",
            studentID: "20240001",
            firstName: "Alex",
            lastName: "Johnson",
            email: email,
            major: "Computer Science",
            year: 3,
            gpa: 3.72,
            profileImageURL: nil
        )

        saveToken("demo_token_\(UUID().uuidString)")
        saveStudent(student)
        return student
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: studentKey)
    }

    func currentStudent() -> Student? {
        guard let data = UserDefaults.standard.data(forKey: studentKey) else { return nil }
        return try? JSONDecoder().decode(Student.self, from: data)
    }

    func isLoggedIn() -> Bool {
        UserDefaults.standard.string(forKey: tokenKey) != nil
    }

    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    private func saveStudent(_ student: Student) {
        if let data = try? JSONEncoder().encode(student) {
            UserDefaults.standard.set(data, forKey: studentKey)
        }
    }
}

// MARK: - Auth Errors
enum AuthError: LocalizedError {
    case invalidCredentials
    case networkError
    case sessionExpired

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password. Please try again."
        case .networkError:
            return "Network error. Please check your connection."
        case .sessionExpired:
            return "Your session has expired. Please log in again."
        }
    }
}
