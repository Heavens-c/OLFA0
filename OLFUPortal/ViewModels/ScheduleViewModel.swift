import Foundation
import Combine

@MainActor
final class ScheduleViewModel: ObservableObject {
    @Published var allScheduleItems: [ScheduleItem] = []
    @Published var todaySchedule: [ScheduleItem] = []
    @Published var selectedDay: DayOfWeek = .today
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var viewMode: ScheduleViewMode = .weekly
    
    enum ScheduleViewMode: String, CaseIterable {
        case weekly = "Weekly"
        case daily = "Daily"
    }
    
    private let service: ScheduleServiceProtocol
    
    init(service: ScheduleServiceProtocol = ScheduleService.shared) {
        self.service = service
    }
    
    var scheduleForSelectedDay: [ScheduleItem] {
        allScheduleItems
            .filter { $0.day == selectedDay }
            .sorted { $0.startTime < $1.startTime }
    }
    
    var groupedByDay: [(DayOfWeek, [ScheduleItem])] {
        let grouped = Dictionary(grouping: allScheduleItems) { $0.day }
        return DayOfWeek.weekdays.compactMap { day in
            guard let items = grouped[day], !items.isEmpty else { return nil }
            return (day, items.sorted { $0.startTime < $1.startTime })
        }
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
    
    func loadSchedule() async {
        isLoading = true
        errorMessage = nil
        
        do {
            allScheduleItems = try await service.fetchSchedule()
            todaySchedule = try await service.fetchTodaySchedule()
        } catch {
            errorMessage = "Failed to load schedule."
        }
        
        isLoading = false
    }
}
