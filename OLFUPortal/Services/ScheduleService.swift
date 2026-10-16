import Foundation

protocol ScheduleServiceProtocol {
    func fetchSchedule() async throws -> [ScheduleItem]
    func fetchScheduleForDay(_ day: DayOfWeek) async throws -> [ScheduleItem]
    func fetchTodaySchedule() async throws -> [ScheduleItem]
}

final class ScheduleService: ScheduleServiceProtocol {
    static let shared = ScheduleService()
    private init() {}
    
    func fetchSchedule() async throws -> [ScheduleItem] {
        try await Task.sleep(nanoseconds: 600_000_000)
        return ScheduleItem.samples
    }
    
    func fetchScheduleForDay(_ day: DayOfWeek) async throws -> [ScheduleItem] {
        try await Task.sleep(nanoseconds: 400_000_000)
        return ScheduleItem.samples
            .filter { $0.day == day }
            .sorted { $0.startTime < $1.startTime }
    }
    
    func fetchTodaySchedule() async throws -> [ScheduleItem] {
        try await Task.sleep(nanoseconds: 400_000_000)
        let today = DayOfWeek.today
        return ScheduleItem.samples
            .filter { $0.day == today }
            .sorted { $0.startTime < $1.startTime }
    }
}
