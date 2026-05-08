import Foundation
import SwiftUI

struct Subject: Codable, Identifiable, Hashable {
    let id: String
    let code: String
    let name: String
    let instructor: String
    let room: String
    let units: Int
    let schedule: String
    let day: String
    let startTime: String
    let endTime: String
    let colorHex: String
    let description: String
    
    var color: Color {
        Color(hex: colorHex)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Subject, rhs: Subject) -> Bool {
        lhs.id == rhs.id
    }
}

extension Subject {
    static let samples: [Subject] = [
        Subject(
            id: "SUBJ-001",
            code: "IT 312",
            name: "Web Development",
            instructor: "Prof. Maria Santos",
            room: "Room 301",
            units: 3,
            schedule: "MWF 9:00 AM - 10:00 AM",
            day: "MWF",
            startTime: "09:00",
            endTime: "10:00",
            colorHex: "#2E7D32",
            description: "This course covers modern web development technologies including HTML5, CSS3, JavaScript, and popular frameworks."
        ),
        Subject(
            id: "SUBJ-002",
            code: "IT 314",
            name: "Mobile App Development",
            instructor: "Prof. Carlos Reyes",
            room: "Room 205",
            units: 3,
            schedule: "TTh 10:30 AM - 12:00 PM",
            day: "TTh",
            startTime: "10:30",
            endTime: "12:00",
            colorHex: "#1565C0",
            description: "Introduction to mobile application development using Swift and SwiftUI for iOS platforms."
        ),
        Subject(
            id: "SUBJ-003",
            code: "IT 316",
            name: "Database Management",
            instructor: "Prof. Ana Lim",
            room: "Room 102",
            units: 3,
            schedule: "MWF 1:00 PM - 2:00 PM",
            day: "MWF",
            startTime: "13:00",
            endTime: "14:00",
            colorHex: "#E65100",
            description: "Study of relational database design, SQL, normalization, and database administration."
        ),
        Subject(
            id: "SUBJ-004",
            code: "GE 101",
            name: "Purposive Communication",
            instructor: "Prof. Roberto Garcia",
            room: "Room 408",
            units: 3,
            schedule: "TTh 1:00 PM - 2:30 PM",
            day: "TTh",
            startTime: "13:00",
            endTime: "14:30",
            colorHex: "#6A1B9A",
            description: "Development of communication skills for professional and academic purposes."
        ),
        Subject(
            id: "SUBJ-005",
            code: "IT 318",
            name: "Networking Fundamentals",
            instructor: "Prof. Lisa Tan",
            room: "Lab 3",
            units: 3,
            schedule: "MWF 3:00 PM - 4:00 PM",
            day: "MWF",
            startTime: "15:00",
            endTime: "16:00",
            colorHex: "#00838F",
            description: "Fundamentals of computer networking, protocols, and network security."
        ),
        Subject(
            id: "SUBJ-006",
            code: "MATH 201",
            name: "Discrete Mathematics",
            instructor: "Prof. Elena Cruz",
            room: "Room 310",
            units: 3,
            schedule: "TTh 8:00 AM - 9:30 AM",
            day: "TTh",
            startTime: "08:00",
            endTime: "09:30",
            colorHex: "#AD1457",
            description: "Study of mathematical structures that are fundamentally discrete. Topics include logic, sets, relations, and graph theory."
        ),
        Subject(
            id: "SUBJ-007",
            code: "PE 2",
            name: "Physical Education 2",
            instructor: "Prof. Mark Villanueva",
            room: "Gym",
            units: 2,
            schedule: "Sat 8:00 AM - 10:00 AM",
            day: "Sat",
            startTime: "08:00",
            endTime: "10:00",
            colorHex: "#33691E",
            description: "Physical fitness activities and team sports to promote health and wellness."
        )
    ]
}
