import SwiftUI

// MARK: - MainTabView
struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var announcementsVM = AnnouncementsViewModel()

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            CoursesView()
                .tabItem {
                    Label("Courses", systemImage: "books.vertical.fill")
                }

            AssignmentsView()
                .tabItem {
                    Label("Assignments", systemImage: "checklist")
                }

            GradesView()
                .tabItem {
                    Label("Grades", systemImage: "chart.bar.fill")
                }

            AnnouncementsView()
                .tabItem {
                    Label("Notices", systemImage: "bell.fill")
                }
                .badge(announcementsVM.unreadCount > 0 ? announcementsVM.unreadCount : 0)
        }
        .environmentObject(announcementsVM)
    }
}

// MARK: - DashboardView
struct DashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var coursesVM = CoursesViewModel()
    @StateObject private var assignmentsVM = AssignmentsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Greeting
                    greetingSection

                    // Quick Stats
                    quickStatsSection

                    // Today's Schedule
                    todayScheduleSection

                    // Upcoming Assignments
                    upcomingAssignmentsSection

                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        ProfileView()
                            .environmentObject(authViewModel)
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
            .task {
                await coursesVM.fetchCourses()
                await assignmentsVM.fetchAssignments()
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: Greeting
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greetingText)
                .font(.title2)
                .foregroundColor(.secondary)
            Text(authViewModel.currentStudent?.firstName ?? "Student")
                .font(.largeTitle.bold())
            Text("GPA: \(String(format: "%.2f", authViewModel.currentStudent?.gpa ?? 0.0)) · \(authViewModel.currentStudent?.major ?? "")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good morning,"
        case 12..<17: return "Good afternoon,"
        default: return "Good evening,"
        }
    }

    // MARK: Quick Stats
    private var quickStatsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(title: "Enrolled", value: "\(coursesVM.courses.count)", subtitle: "courses", icon: "books.vertical.fill", color: .blue)
            StatCard(title: "Pending", value: "\(assignmentsVM.pending.count)", subtitle: "assignments", icon: "checklist", color: .orange)
            StatCard(title: "GPA", value: String(format: "%.2f", authViewModel.currentStudent?.gpa ?? 0.0), subtitle: "cumulative", icon: "chart.bar.fill", color: .green)
            StatCard(title: "Year", value: authViewModel.currentStudent?.displayYear ?? "—", subtitle: authViewModel.currentStudent?.major ?? "", icon: "graduationcap.fill", color: .purple)
        }
    }

    // MARK: Today's Schedule
    private var todayScheduleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Today's Classes", icon: "calendar")

            let todayCourses = coursesVM.courses.filter { course in
                let weekday = Calendar.current.component(.weekday, from: Date())
                return course.schedule.contains { sched in
                    switch weekday {
                    case 2: return sched.day == .monday
                    case 3: return sched.day == .tuesday
                    case 4: return sched.day == .wednesday
                    case 5: return sched.day == .thursday
                    case 6: return sched.day == .friday
                    default: return false
                    }
                }
            }

            if todayCourses.isEmpty {
                EmptyStateSmall(icon: "sun.max.fill", message: "No classes today!")
            } else {
                ForEach(todayCourses) { course in
                    TodayCourseRow(course: course)
                }
            }
        }
    }

    // MARK: Upcoming Assignments
    private var upcomingAssignmentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Due Soon", icon: "clock.fill")

            let upcoming = assignmentsVM.pending.prefix(3)
            if upcoming.isEmpty {
                EmptyStateSmall(icon: "checkmark.circle.fill", message: "No pending assignments!")
            } else {
                ForEach(Array(upcoming)) { assignment in
                    AssignmentRowSmall(assignment: assignment)
                }
            }
        }
    }
}
