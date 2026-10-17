import Foundation

// MARK: - Student Model
struct Student: Identifiable, Codable {
    let id: String
    let studentID: String
    let firstName: String
    let lastName: String
    let email: String
    let major: String
    let year: Int
    let gpa: Double
    let profileImageURL: String?

    var fullName: String { "\(firstName) \(lastName)" }
    var displayYear: String {
        switch year {
        case 1: return "Freshman"
        case 2: return "Sophomore"
        case 3: return "Junior"
        case 4: return "Senior"
        default: return "Year \(year)"
        }
    }
}

// MARK: - Course Model
struct Course: Identifiable, Codable {
    let id: String
    let code: String
    let name: String
    let instructor: String
    let credits: Int
    let schedule: [ClassSchedule]
    let room: String
    let description: String
    var enrollmentStatus: EnrollmentStatus

    enum EnrollmentStatus: String, Codable {
        case enrolled = "Enrolled"
        case waitlisted = "Waitlisted"
        case completed = "Completed"
    }
}

// MARK: - Class Schedule
struct ClassSchedule: Codable {
    let day: Weekday
    let startTime: String
    let endTime: String

    enum Weekday: String, Codable, CaseIterable {
        case monday = "Mon"
        case tuesday = "Tue"
        case wednesday = "Wed"
        case thursday = "Thu"
        case friday = "Fri"
        case saturday = "Sat"
        case sunday = "Sun"
    }
}

// MARK: - Grade Model
struct Grade: Identifiable, Codable {
    let id: String
    let courseID: String
    let courseName: String
    let courseCode: String
    let letterGrade: String
    let numericGrade: Double
    let credits: Int
    let semester: String
    let year: Int

    var gradePoints: Double {
        switch letterGrade {
        case "A+", "A": return 4.0
        case "A-": return 3.7
        case "B+": return 3.3
        case "B": return 3.0
        case "B-": return 2.7
        case "C+": return 2.3
        case "C": return 2.0
        case "C-": return 1.7
        case "D+": return 1.3
        case "D": return 1.0
        case "F": return 0.0
        default: return 0.0
        }
    }

    var gradeColor: String {
        switch letterGrade {
        case "A+", "A", "A-": return "green"
        case "B+", "B", "B-": return "blue"
        case "C+", "C", "C-": return "orange"
        default: return "red"
        }
    }
}

// MARK: - Assignment Model
struct Assignment: Identifiable, Codable {
    let id: String
    let courseID: String
    let courseName: String
    let title: String
    let description: String
    let dueDate: Date
    let maxPoints: Double
    var status: AssignmentStatus
    var earnedPoints: Double?

    enum AssignmentStatus: String, Codable {
        case pending = "Pending"
        case submitted = "Submitted"
        case graded = "Graded"
        case late = "Late"
        case missing = "Missing"
    }

    var isOverdue: Bool {
        dueDate < Date() && status == .pending
    }

    var daysUntilDue: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
    }
}

// MARK: - Announcement Model
struct Announcement: Identifiable, Codable {
    let id: String
    let title: String
    let body: String
    let author: String
    let category: AnnouncementCategory
    let datePosted: Date
    var isRead: Bool

    enum AnnouncementCategory: String, Codable, CaseIterable {
        case general = "General"
        case academic = "Academic"
        case events = "Events"
        case emergency = "Emergency"
        case financial = "Financial"

        var iconName: String {
            switch self {
            case .general: return "megaphone.fill"
            case .academic: return "book.fill"
            case .events: return "calendar"
            case .emergency: return "exclamationmark.triangle.fill"
            case .financial: return "dollarsign.circle.fill"
            }
        }
    }
}

// MARK: - Transcript Model
struct Transcript: Codable {
    let studentID: String
    let grades: [Grade]
    var cumulativeGPA: Double
    var totalCreditsEarned: Int
    var totalCreditsAttempted: Int
}
