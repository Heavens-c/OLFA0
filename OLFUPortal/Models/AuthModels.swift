import Foundation

struct AuthResponse: Codable {
    let success: Bool
    let message: String
    let token: String?
    let user: User?
}

struct APIError: Codable, Error, LocalizedError {
    let code: Int
    let message: String
    
    var errorDescription: String? { message }
    
    static let unauthorized = APIError(code: 401, message: "Invalid email or password. Please try again.")
    static let networkError = APIError(code: -1, message: "Network error. Please check your connection.")
    static let serverError = APIError(code: 500, message: "Server error. Please try again later.")
    static let validationError = APIError(code: 422, message: "Please check your input and try again.")
    static let notFound = APIError(code: 404, message: "The requested resource was not found.")
    static let unknown = APIError(code: -2, message: "An unexpected error occurred.")
}

struct RegistrationRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let studentID: String
    let course: String
    let yearLevel: Int
}
