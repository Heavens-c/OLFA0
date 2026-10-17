import SwiftUI

// MARK: - GradesView
struct GradesView: View {
    @StateObject private var viewModel = GradesViewModel()
    @State private var selectedSegment = 0
    private let segments = ["Current Semester", "Transcript"]

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    LoadingView(message: "Loading grades...")
                } else {
                    gradesContent
                }
            }
            .navigationTitle("Grades")
            .navigationBarTitleDisplayMode(.large)
            .task { await viewModel.fetchData() }
            .refreshable { await viewModel.fetchData() }
        }
        .navigationViewStyle(.stack)
    }

    private var gradesContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                // GPA Banner
                gpaBanner

                // Segmented Control
                Picker("View", selection: $selectedSegment) {
                    ForEach(0..<segments.count, id: \.self) {
                        Text(segments[$0]).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if selectedSegment == 0 {
                    currentSemesterView
                } else {
                    transcriptView
                }
            }
            .padding(.bottom, 20)
        }
    }

    // MARK: GPA Banner
    private var gpaBanner: some View {
        HStack(spacing: 0) {
            Spacer()
            gpaStatItem(value: String(format: "%.2f", viewModel.transcript?.cumulativeGPA ?? 0), label: "Cumulative GPA")
            Divider().frame(height: 40)
            gpaStatItem(value: "\(viewModel.transcript?.totalCreditsEarned ?? 0)", label: "Credits Earned")
            Divider().frame(height: 40)
            gpaStatItem(value: "\(viewModel.grades.count)", label: "Courses")
            Spacer()
        }
        .padding(.vertical, 20)
        .background(
            LinearGradient(
                colors: [Color.green.opacity(0.7), Color.teal],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private func gpaStatItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Current Semester
    private var currentSemesterView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fall 2024")
                .font(.headline)
                .padding(.horizontal)

            ForEach(viewModel.currentSemesterGrades) { grade in
                GradeRow(grade: grade)
                    .padding(.horizontal)
            }

            if viewModel.currentSemesterGrades.isEmpty {
                EmptyStateSmall(icon: "doc.text.fill", message: "No grades posted yet for this semester.")
                    .padding()
            }
        }
    }

    // MARK: Transcript
    private var transcriptView: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(viewModel.semesterGroups, id: \.0) { semester, grades in
                VStack(alignment: .leading, spacing: 8) {
                    Text(semester)
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(grades) { grade in
                        GradeRow(grade: grade)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

// MARK: - GradeRow
struct GradeRow: View {
    let grade: Grade

    var gradeColor: Color {
        switch grade.letterGrade {
        case "A+", "A", "A-": return .green
        case "B+", "B", "B-": return .blue
        case "C+", "C", "C-": return .orange
        default: return .red
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            // Grade badge
            Text(grade.letterGrade)
                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(gradeColor)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 2) {
                Text(grade.courseName)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                Text(grade.courseCode)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.1f%%", grade.numericGrade))
                    .font(.subheadline.bold())
                    .foregroundColor(gradeColor)
                Text("\(grade.credits) cr")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
