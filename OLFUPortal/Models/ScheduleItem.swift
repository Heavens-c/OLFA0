import Foundation

struct ScheduleItem: Codable, Identifiable {
    let id: String
    let subjectID: String
    let subjectCode: String
    let subjectName: String
    let instructor: String
    let room: String
    let day: DayOfWeek
    let startTime: String
    let endTime: String
    let colorHex: String
    
    var startDate: Date {
        timeFromString(startTime)
    }
    
    var endDate: Date {
        timeFromString(endTime)
    }
    
    var formattedTime: String {
        "\(formatTimeString(startTime)) - \(formatTimeString(endTime))"
    }
    
    var isCurrentlyOngoing: Bool {
        let calendar = Calendar.current
        let now = Date()
        let currentWeekday = calendar.component(.weekday, from: now)
        
        guard day.weekdayNumber == currentWeekday else { return false }
        
        let start = startDate
        let end = endDate
        let nowTime = calendar.date(
            bySettingHour: calendar.component(.hour, from: now),
            minute: calendar.component(.minute, from: now),
            second: 0,
            of: now
        )!
        
        let startTimeOnly = calendar.date(
            bySettingHour: calendar.component(.hour, from: start),
            minute: calendar.component(.minute, from: start),
            second: 0,
            of: now
        )!
        
        let endTimeOnly = calendar.date(
            bySettingHour: calendar.component(.hour, from: end),
            minute: calendar.component(.minute, from: end),
            second: 0,
            of: now
        )!
        
        return nowTime >= startTimeOnly && nowTime <= endTimeOnly
    }
    
    private func timeFromString(_ time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: time) ?? Date()
    }
    
    private func formatTimeString(_ time: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let date = formatter.date(from: time) else { return time }
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

enum DayOfWeek: String, Codable, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    var shortName: String {
        switch self {
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        case .sunday: return "Sun"
        }
    }
    
    var initial: String {
        String(rawValue.prefix(1))
    }
    
    var weekdayNumber: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
    
    static var today: DayOfWeek {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return DayOfWeek.allCases.first { $0.weekdayNumber == weekday } ?? .monday
    }
    
    static var weekdays: [DayOfWeek] {
        [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    }
}

extension ScheduleItem {
    static let samples: [ScheduleItem] = [
        // Monday/Wednesday/Friday
        ScheduleItem(id: "SCH-001", subjectID: "SUBJ-001", subjectCode: "IT 312", subjectName: "Web Development", instructor: "Prof. Maria Santos", room: "Room 301", day: .monday, startTime: "09:00", endTime: "10:00", colorHex: "#2E7D32"),
        ScheduleItem(id: "SCH-002", subjectID: "SUBJ-001", subjectCode: "IT 312", subjectName: "Web Development", instructor: "Prof. Maria Santos", room: "Room 301", day: .wednesday, startTime: "09:00", endTime: "10:00", colorHex: "#2E7D32"),
        ScheduleItem(id: "SCH-003", subjectID: "SUBJ-001", subjectCode: "IT 312", subjectName: "Web Development", instructor: "Prof. Maria Santos", room: "Room 301", day: .friday, startTime: "09:00", endTime: "10:00", colorHex: "#2E7D32"),
        
        ScheduleItem(id: "SCH-004", subjectID: "SUBJ-003", subjectCode: "IT 316", subjectName: "Database Management", instructor: "Prof. Ana Lim", room: "Room 102", day: .monday, startTime: "13:00", endTime: "14:00", colorHex: "#E65100"),
        ScheduleItem(id: "SCH-005", subjectID: "SUBJ-003", subjectCode: "IT 316", subjectName: "Database Management", instructor: "Prof. Ana Lim", room: "Room 102", day: .wednesday, startTime: "13:00", endTime: "14:00", colorHex: "#E65100"),
        ScheduleItem(id: "SCH-006", subjectID: "SUBJ-003", subjectCode: "IT 316", subjectName: "Database Management", instructor: "Prof. Ana Lim", room: "Room 102", day: .friday, startTime: "13:00", endTime: "14:00", colorHex: "#E65100"),
        
        ScheduleItem(id: "SCH-007", subjectID: "SUBJ-005", subjectCode: "IT 318", subjectName: "Networking Fundamentals", instructor: "Prof. Lisa Tan", room: "Lab 3", day: .monday, startTime: "15:00", endTime: "16:00", colorHex: "#00838F"),
        ScheduleItem(id: "SCH-008", subjectID: "SUBJ-005", subjectCode: "IT 318", subjectName: "Networking Fundamentals", instructor: "Prof. Lisa Tan", room: "Lab 3", day: .wednesday, startTime: "15:00", endTime: "16:00", colorHex: "#00838F"),
        ScheduleItem(id: "SCH-009", subjectID: "SUBJ-005", subjectCode: "IT 318", subjectName: "Networking Fundamentals", instructor: "Prof. Lisa Tan", room: "Lab 3", day: .friday, startTime: "15:00", endTime: "16:00", colorHex: "#00838F"),
        
        // Tuesday/Thursday
        ScheduleItem(id: "SCH-010", subjectID: "SUBJ-006", subjectCode: "MATH 201", subjectName: "Discrete Mathematics", instructor: "Prof. Elena Cruz", room: "Room 310", day: .tuesday, startTime: "08:00", endTime: "09:30", colorHex: "#AD1457"),
        ScheduleItem(id: "SCH-011", subjectID: "SUBJ-006", subjectCode: "MATH 201", subjectName: "Discrete Mathematics", instructor: "Prof. Elena Cruz", room: "Room 310", day: .thursday, startTime: "08:00", endTime: "09:30", colorHex: "#AD1457"),
        
        ScheduleItem(id: "SCH-012", subjectID: "SUBJ-002", subjectCode: "IT 314", subjectName: "Mobile App Development", instructor: "Prof. Carlos Reyes", room: "Room 205", day: .tuesday, startTime: "10:30", endTime: "12:00", colorHex: "#1565C0"),
        ScheduleItem(id: "SCH-013", subjectID: "SUBJ-002", subjectCode: "IT 314", subjectName: "Mobile App Development", instructor: "Prof. Carlos Reyes", room: "Room 205", day: .thursday, startTime: "10:30", endTime: "12:00", colorHex: "#1565C0"),
        
        ScheduleItem(id: "SCH-014", subjectID: "SUBJ-004", subjectCode: "GE 101", subjectName: "Purposive Communication", instructor: "Prof. Roberto Garcia", room: "Room 408", day: .tuesday, startTime: "13:00", endTime: "14:30", colorHex: "#6A1B9A"),
        ScheduleItem(id: "SCH-015", subjectID: "SUBJ-004", subjectCode: "GE 101", subjectName: "Purposive Communication", instructor: "Prof. Roberto Garcia", room: "Room 408", day: .thursday, startTime: "13:00", endTime: "14:30", colorHex: "#6A1B9A"),
        
        // Saturday
        ScheduleItem(id: "SCH-016", subjectID: "SUBJ-007", subjectCode: "PE 2", subjectName: "Physical Education 2", instructor: "Prof. Mark Villanueva", room: "Gym", day: .saturday, startTime: "08:00", endTime: "10:00", colorHex: "#33691E")
    ]
}
