import SwiftUI

// MARK: - ScheduleView
struct ScheduleView: View {
    @StateObject private var viewModel = CoursesViewModel()
    private let weekdays: [ClassSchedule.Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    @State private var selectedDay: ClassSchedule.Weekday = {
        let weekday = Calendar.current.component(.weekday, from: Date())
        switch weekday {
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        default: return .monday
        }
    }()

    var coursesForDay: [Course] {
        viewModel.courses.filter { course in
            course.schedule.contains { $0.day == selectedDay }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                daySelector

                Divider()

                if viewModel.isLoading {
                    LoadingView(message: "Loading schedule...")
                } else if coursesForDay.isEmpty {
                    emptyDayView
                } else {
                    scheduleList
                }
            }
            .navigationTitle("Schedule")
            .navigationBarTitleDisplayMode(.large)
            .task { await viewModel.fetchCourses() }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: Day Selector
    private var daySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(weekdays, id: \.self) { day in
                    Button {
                        selectedDay = day
                    } label: {
                        VStack(spacing: 4) {
                            Text(day.rawValue)
                                .font(.caption.bold())
                            Circle()
                                .fill(selectedDay == day ? Color.blue : Color.clear)
                                .frame(width: 6, height: 6)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(selectedDay == day ? Color.blue : Color(.secondarySystemBackground))
                        .foregroundColor(selectedDay == day ? .white : .primary)
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
    }

    // MARK: Schedule List
    private var scheduleList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                ForEach(coursesForDay) { course in
                    let sched = course.schedule.first { $0.day == selectedDay }!
                    ScheduleCard(course: course, schedule: sched)
                }
            }
            .padding()
        }
    }

    // MARK: Empty Day
    private var emptyDayView: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.checkmark")
                .font(.system(size: 60))
                .foregroundColor(.green.opacity(0.5))
            Text("No classes on \(selectedDay.rawValue)")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Enjoy your free day!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - ScheduleCard
struct ScheduleCard: View {
    let course: Course
    let schedule: ClassSchedule

    var body: some View {
        HStack(spacing: 0) {
            // Time column
            VStack(alignment: .trailing, spacing: 4) {
                Text(schedule.startTime)
                    .font(.subheadline.bold())
                Spacer()
                Text(schedule.endTime)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 55)

            // Line
            VStack(spacing: 0) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 2)
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
            .padding(.horizontal, 12)

            // Card
            VStack(alignment: .leading, spacing: 6) {
                Text(course.code)
                    .font(.caption.bold())
                    .foregroundColor(.blue)
                Text(course.name)
                    .font(.subheadline.bold())
                    .lineLimit(2)
                HStack(spacing: 4) {
                    Image(systemName: "mappin.fill")
                        .font(.caption2)
                    Text(course.room)
                    Spacer()
                    Image(systemName: "person.fill")
                        .font(.caption2)
                    Text(course.instructor.components(separatedBy: " ").last ?? "")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
}
