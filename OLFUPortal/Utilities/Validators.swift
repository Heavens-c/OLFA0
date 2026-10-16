import Foundation

struct Validators {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    static func isValidStudentID(_ id: String) -> Bool {
        let idRegex = #"^\d{4}-\d{5}$"#
        return id.range(of: idRegex, options: .regularExpression) != nil
    }
    
    static func isNotEmpty(_ value: String) -> Bool {
        return !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    static func passwordsMatch(_ password: String, _ confirm: String) -> Bool {
        return password == confirm && !password.isEmpty
    }
}
