import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var todaySchedule: [ScheduleItem] = []
    @Published var subjects: [Subject] = []
    @Published var recentNotes: [Note] = []
    @Published var isLoading = false
    
    private let scheduleService: ScheduleServiceProtocol
    private let subjectService: SubjectServiceProtocol
    private let noteService: NoteServiceProtocol
    
    init(
        scheduleService: ScheduleServiceProtocol = ScheduleService.shared,
        subjectService: SubjectServiceProtocol = SubjectService.shared,
        noteService: NoteServiceProtocol = NoteService.shared
    ) {
        self.scheduleService = scheduleService
        self.subjectService = subjectService
        self.noteService = noteService
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
    
    var todayDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: Date())
    }
    
    var upcomingClasses: [ScheduleItem] {
        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)
        let currentTimeString = String(format: "%02d:%02d", currentHour, currentMinute)
        
        return todaySchedule.filter { $0.startTime > currentTimeString }
    }
    
    var currentClass: ScheduleItem? {
        todaySchedule.first { $0.isCurrentlyOngoing }
    }
    
    func loadDashboard() async {
        isLoading = true
        
        async let scheduleTask = scheduleService.fetchTodaySchedule()
        async let subjectsTask = subjectService.fetchSubjects()
        async let notesTask = noteService.fetchNotes()
        
        do {
            todaySchedule = try await scheduleTask
            subjects = try await subjectsTask
            let allNotes = try await notesTask
            recentNotes = Array(allNotes.prefix(3))
        } catch {
            // Graceful degradation — dashboard shows what loaded
        }
        
        isLoading = false
    }
}
