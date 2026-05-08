import Foundation

struct User: Codable, Identifiable {
    let id: String
    var firstName: String
    var lastName: String
    var email: String
    var studentID: String
    var course: String
    var yearLevel: Int
    var section: String
    var profileImageURL: String?
    var phoneNumber: String?
    var address: String?
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var yearLevelString: String {
        switch yearLevel {
        case 1: return "1st Year"
        case 2: return "2nd Year"
        case 3: return "3rd Year"
        case 4: return "4th Year"
        case 5: return "5th Year"
        default: return "\(yearLevel)th Year"
        }
    }
    
    var courseAndYear: String {
        "\(course) - \(yearLevelString)"
    }
}

extension User {
    static let sample = User(
        id: "USR-001",
        firstName: "Juan",
        lastName: "Dela Cruz",
        email: "juan.delacruz@olfu.edu.ph",
        studentID: "2024-00123",
        course: "BSIT",
        yearLevel: 2,
        section: "2A",
        profileImageURL: nil,
        phoneNumber: "+63 912 345 6789",
        address: "Valenzuela City, Metro Manila"
    )
}
