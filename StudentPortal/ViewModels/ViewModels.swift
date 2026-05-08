import Foundation
import Combine

// MARK: - AuthViewModel
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentStudent: Student?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let authService = AuthService.shared

    init() {
        checkExistingSession()
    }

    private func checkExistingSession() {
        if authService.isLoggedIn(), let student = authService.currentStudent() {
            self.currentStudent = student
            self.isAuthenticated = true
        }
    }

    @MainActor
    func login(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            let student = try await authService.login(email: email, password: password)
            self.currentStudent = student
            self.isAuthenticated = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func logout() {
        authService.logout()
        currentStudent = nil
        isAuthenticated = false
    }
}

// MARK: - CoursesViewModel
class CoursesViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @MainActor
    func fetchCourses() async {
        isLoading = true
        errorMessage = nil
        do {
            courses = try await CourseService.shared.fetchEnrolledCourses()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

// MARK: - GradesViewModel
class GradesViewModel: ObservableObject {
    @Published var grades: [Grade] = []
    @Published var transcript: Transcript?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    var currentSemesterGrades: [Grade] {
        grades.filter { $0.semester == "Fall" && $0.year == 2024 }
    }

    var semesterGroups: [(String, [Grade])] {
        let grouped = Dictionary(grouping: grades) { "\($0.semester) \($0.year)" }
        return grouped.sorted { $0.key > $1.key }.map { ($0.key, $0.value) }
    }

    @MainActor
    func fetchData() async {
        isLoading = true
        errorMessage = nil
        do {
            async let gradesTask = GradeService.shared.fetchGrades()
            async let transcriptTask = GradeService.shared.fetchTranscript()
            grades = try await gradesTask
            transcript = try await transcriptTask
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

// MARK: - AssignmentsViewModel
class AssignmentsViewModel: ObservableObject {
    @Published var assignments: [Assignment] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    var pending: [Assignment] {
        assignments.filter { $0.status == .pending }.sorted { $0.dueDate < $1.dueDate }
    }
    var submitted: [Assignment] {
        assignments.filter { $0.status == .submitted }
    }
    var graded: [Assignment] {
        assignments.filter { $0.status == .graded }
    }

    @MainActor
    func fetchAssignments() async {
        isLoading = true
        do {
            assignments = try await AssignmentService.shared.fetchAssignments()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

// MARK: - AnnouncementsViewModel
class AnnouncementsViewModel: ObservableObject {
    @Published var announcements: [Announcement] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    var unreadCount: Int { announcements.filter { !$0.isRead }.count }

    @MainActor
    func fetchAnnouncements() async {
        isLoading = true
        do {
            announcements = try await AnnouncementService.shared.fetchAnnouncements()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func markAsRead(_ announcement: Announcement) {
        if let index = announcements.firstIndex(where: { $0.id == announcement.id }) {
            announcements[index].isRead = true
        }
    }

    func markAllAsRead() {
        for index in announcements.indices {
            announcements[index].isRead = true
        }
    }
}
