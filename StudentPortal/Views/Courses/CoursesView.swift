import SwiftUI

// MARK: - CoursesView
struct CoursesView: View {
    @StateObject private var viewModel = CoursesViewModel()
    @State private var searchText = ""
    @State private var selectedCourse: Course?

    var filteredCourses: [Course] {
        if searchText.isEmpty { return viewModel.courses }
        return viewModel.courses.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.code.localizedCaseInsensitiveContains(searchText) ||
            $0.instructor.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    LoadingView(message: "Loading courses...")
                } else {
                    coursesList
                }
            }
            .navigationTitle("My Courses")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search courses")
            .task { await viewModel.fetchCourses() }
            .refreshable { await viewModel.fetchCourses() }
        }
        .navigationViewStyle(.stack)
    }

    private var coursesList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                // Credits summary
                HStack {
                    Text("\(viewModel.courses.count) courses enrolled")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(viewModel.courses.reduce(0) { $0 + $1.credits }) credits")
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                ForEach(filteredCourses) { course in
                    NavigationLink {
                        CourseDetailView(course: course)
                    } label: {
                        CourseCard(course: course)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 20)
        }
    }
}

// MARK: - CourseDetailView
struct CourseDetailView: View {
    let course: Course

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Card
                headerCard

                // Info Sections
                infoSection(title: "Course Description", icon: "text.alignleft") {
                    Text(course.description)
                        .font(.body)
                        .foregroundColor(.primary)
                }

                infoSection(title: "Schedule", icon: "calendar") {
                    ForEach(course.schedule, id: \.day) { sched in
                        HStack {
                            Text(sched.day.rawValue)
                                .font(.subheadline.bold())
                                .frame(width: 44, alignment: .leading)
                            Text("\(sched.startTime) – \(sched.endTime)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                infoSection(title: "Details", icon: "info.circle.fill") {
                    DetailRow(label: "Instructor", value: course.instructor)
                    DetailRow(label: "Room", value: course.room)
                    DetailRow(label: "Credits", value: "\(course.credits)")
                    DetailRow(label: "Status", value: course.enrollmentStatus.rawValue)
                }
            }
            .padding()
        }
        .navigationTitle(course.code)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(course.code)
                .font(.caption.bold())
                .foregroundColor(.white.opacity(0.8))
            Text(course.name)
                .font(.title2.bold())
                .foregroundColor(.white)
            Text(course.instructor)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.blue, Color.indigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }

    private func infoSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundColor(.primary)
            content()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - CourseCard
struct CourseCard: View {
    let course: Course

    var body: some View {
        HStack(spacing: 16) {
            // Color accent
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue)
                .frame(width: 4)
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(course.code)
                        .font(.caption.bold())
                        .foregroundColor(.blue)
                    Spacer()
                    Text("\(course.credits) cr")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                }
                Text(course.name)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(course.instructor)
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(course.room)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(course.schedule.map(\.day.rawValue).joined(separator: "/"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
