import Foundation

// MARK: - CourseService
class CourseService {
    static let shared = CourseService()
    private init() {}

    func fetchEnrolledCourses() async throws -> [Course] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return Course.mockData()
    }
}

// MARK: - GradeService
class GradeService {
    static let shared = GradeService()
    private init() {}

    func fetchGrades() async throws -> [Grade] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return Grade.mockData()
    }

    func fetchTranscript() async throws -> Transcript {
        try await Task.sleep(nanoseconds: 500_000_000)
        return Transcript.mock()
    }
}

// MARK: - AssignmentService
class AssignmentService {
    static let shared = AssignmentService()
    private init() {}

    func fetchAssignments() async throws -> [Assignment] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return Assignment.mockData()
    }
}

// MARK: - AnnouncementService
class AnnouncementService {
    static let shared = AnnouncementService()
    private init() {}

    func fetchAnnouncements() async throws -> [Announcement] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return Announcement.mockData()
    }
}

// MARK: - Mock Data Extensions
extension Course {
    static func mockData() -> [Course] {
        [
            Course(
                id: "C001",
                code: "CS 301",
                name: "Data Structures & Algorithms",
                instructor: "Dr. Sarah Mitchell",
                credits: 3,
                schedule: [
                    ClassSchedule(day: .monday, startTime: "09:00", endTime: "10:15"),
                    ClassSchedule(day: .wednesday, startTime: "09:00", endTime: "10:15")
                ],
                room: "STEM 204",
                description: "Study of fundamental data structures and algorithm design techniques.",
                enrollmentStatus: .enrolled
            ),
            Course(
                id: "C002",
                code: "MATH 302",
                name: "Linear Algebra",
                instructor: "Prof. James Carter",
                credits: 3,
                schedule: [
                    ClassSchedule(day: .tuesday, startTime: "11:00", endTime: "12:15"),
                    ClassSchedule(day: .thursday, startTime: "11:00", endTime: "12:15")
                ],
                room: "MATH 110",
                description: "Vector spaces, linear transformations, matrices, and eigenvalues.",
                enrollmentStatus: .enrolled
            ),
            Course(
                id: "C003",
                code: "CS 350",
                name: "Software Engineering",
                instructor: "Dr. Rachel Chen",
                credits: 3,
                schedule: [
                    ClassSchedule(day: .monday, startTime: "13:00", endTime: "14:15"),
                    ClassSchedule(day: .friday, startTime: "13:00", endTime: "14:15")
                ],
                room: "CS 302",
                description: "Software development lifecycle, design patterns, and agile methodologies.",
                enrollmentStatus: .enrolled
            ),
            Course(
                id: "C004",
                code: "PHYS 201",
                name: "Physics II",
                instructor: "Dr. Mark Torres",
                credits: 4,
                schedule: [
                    ClassSchedule(day: .tuesday, startTime: "08:00", endTime: "09:15"),
                    ClassSchedule(day: .thursday, startTime: "08:00", endTime: "09:15"),
                    ClassSchedule(day: .friday, startTime: "14:00", endTime: "16:00")
                ],
                room: "SCI 105",
                description: "Electricity, magnetism, waves, and optics with lab component.",
                enrollmentStatus: .enrolled
            ),
            Course(
                id: "C005",
                code: "ENG 201",
                name: "Technical Writing",
                instructor: "Prof. Linda Park",
                credits: 2,
                schedule: [
                    ClassSchedule(day: .wednesday, startTime: "15:00", endTime: "16:50")
                ],
                room: "HUM 220",
                description: "Writing for technical and professional contexts.",
                enrollmentStatus: .enrolled
            )
        ]
    }
}

extension Grade {
    static func mockData() -> [Grade] {
        [
            Grade(id: "G001", courseID: "C101", courseName: "Introduction to Programming",
                  courseCode: "CS 101", letterGrade: "A", numericGrade: 95.0,
                  credits: 3, semester: "Fall", year: 2023),
            Grade(id: "G002", courseID: "C102", courseName: "Calculus I",
                  courseCode: "MATH 101", letterGrade: "B+", numericGrade: 88.0,
                  credits: 4, semester: "Fall", year: 2023),
            Grade(id: "G003", courseID: "C103", courseName: "English Composition",
                  courseCode: "ENG 101", letterGrade: "A-", numericGrade: 92.0,
                  credits: 3, semester: "Fall", year: 2023),
            Grade(id: "G004", courseID: "C104", courseName: "Computer Organization",
                  courseCode: "CS 201", letterGrade: "A", numericGrade: 96.0,
                  credits: 3, semester: "Spring", year: 2024),
            Grade(id: "G005", courseID: "C105", courseName: "Calculus II",
                  courseCode: "MATH 201", letterGrade: "B", numericGrade: 83.0,
                  credits: 4, semester: "Spring", year: 2024),
            Grade(id: "G006", courseID: "C106", courseName: "Discrete Mathematics",
                  courseCode: "MATH 220", letterGrade: "A-", numericGrade: 91.0,
                  credits: 3, semester: "Spring", year: 2024),
            Grade(id: "G007", courseID: "C107", courseName: "Database Systems",
                  courseCode: "CS 280", letterGrade: "A+", numericGrade: 98.0,
                  credits: 3, semester: "Fall", year: 2024),
            Grade(id: "G008", courseID: "C108", courseName: "Operating Systems",
                  courseCode: "CS 290", letterGrade: "B+", numericGrade: 87.0,
                  credits: 3, semester: "Fall", year: 2024)
        ]
    }
}

extension Transcript {
    static func mock() -> Transcript {
        Transcript(
            studentID: "STU-001",
            grades: Grade.mockData(),
            cumulativeGPA: 3.72,
            totalCreditsEarned: 80,
            totalCreditsAttempted: 80
        )
    }
}

extension Assignment {
    static func mockData() -> [Assignment] {
        let calendar = Calendar.current
        let now = Date()
        return [
            Assignment(
                id: "A001", courseID: "C001", courseName: "CS 301",
                title: "Implement Binary Search Tree",
                description: "Implement a full BST with insert, delete, and traversal operations in Swift.",
                dueDate: calendar.date(byAdding: .day, value: 3, to: now)!,
                maxPoints: 100, status: .pending, earnedPoints: nil
            ),
            Assignment(
                id: "A002", courseID: "C002", courseName: "MATH 302",
                title: "Problem Set 5: Eigenvalues",
                description: "Solve problems 1–15 from Chapter 5 on eigenvalues and eigenvectors.",
                dueDate: calendar.date(byAdding: .day, value: 1, to: now)!,
                maxPoints: 50, status: .pending, earnedPoints: nil
            ),
            Assignment(
                id: "A003", courseID: "C003", courseName: "CS 350",
                title: "Sprint 2 Demo",
                description: "Present your project sprint 2 progress to the class.",
                dueDate: calendar.date(byAdding: .day, value: 7, to: now)!,
                maxPoints: 100, status: .submitted, earnedPoints: nil
            ),
            Assignment(
                id: "A004", courseID: "C001", courseName: "CS 301",
                title: "Sorting Algorithms Analysis",
                description: "Analyze time and space complexity of five sorting algorithms.",
                dueDate: calendar.date(byAdding: .day, value: -2, to: now)!,
                maxPoints: 80, status: .graded, earnedPoints: 76
            ),
            Assignment(
                id: "A005", courseID: "C004", courseName: "PHYS 201",
                title: "Lab Report: Electromagnetic Fields",
                description: "Write up results from the electromagnetic field experiment.",
                dueDate: calendar.date(byAdding: .day, value: 5, to: now)!,
                maxPoints: 50, status: .pending, earnedPoints: nil
            ),
            Assignment(
                id: "A006", courseID: "C005", courseName: "ENG 201",
                title: "Technical Proposal Draft",
                description: "Submit a first draft of your technical project proposal.",
                dueDate: calendar.date(byAdding: .day, value: -5, to: now)!,
                maxPoints: 100, status: .graded, earnedPoints: 88
            )
        ]
    }
}

extension Announcement {
    static func mockData() -> [Announcement] {
        let calendar = Calendar.current
        let now = Date()
        return [
            Announcement(
                id: "AN001",
                title: "Fall Registration Opens Next Week",
                body: "Registration for Fall 2025 semester will open on Monday, April 14 at 8:00 AM. Please meet with your academic advisor before registering. Check the course catalog for updated offerings.",
                author: "Registrar's Office",
                category: .academic,
                datePosted: calendar.date(byAdding: .hour, value: -2, to: now)!,
                isRead: false
            ),
            Announcement(
                id: "AN002",
                title: "Campus Career Fair — April 22",
                body: "The Spring Career Fair will be held in the Student Center on April 22nd from 10 AM to 4 PM. Over 50 employers will be attending. Business professional attire is recommended. Bring printed resumes.",
                author: "Career Services",
                category: .events,
                datePosted: calendar.date(byAdding: .day, value: -1, to: now)!,
                isRead: false
            ),
            Announcement(
                id: "AN003",
                title: "Library Extended Hours During Finals",
                body: "The university library will extend its hours to 24/7 starting April 28 through May 10 to support students during final exams.",
                author: "University Library",
                category: .general,
                datePosted: calendar.date(byAdding: .day, value: -2, to: now)!,
                isRead: true
            ),
            Announcement(
                id: "AN004",
                title: "Financial Aid Deadline Reminder",
                body: "The deadline to submit your FAFSA for the 2025–2026 academic year is April 30. Please log in to the financial aid portal to check your status.",
                author: "Financial Aid Office",
                category: .financial,
                datePosted: calendar.date(byAdding: .day, value: -3, to: now)!,
                isRead: true
            ),
            Announcement(
                id: "AN005",
                title: "Campus Alert: Building Closure",
                body: "Due to a water main break, the Engineering Building (ENGR) will be closed until further notice. Classes normally held in ENGR have been relocated — check your student email for updated room assignments.",
                author: "Facilities Management",
                category: .emergency,
                datePosted: calendar.date(byAdding: .day, value: -4, to: now)!,
                isRead: true
            )
        ]
    }
}
