import SwiftUI

// MARK: - AssignmentsView
struct AssignmentsView: View {
    @StateObject private var viewModel = AssignmentsViewModel()
    @State private var selectedTab = 0
    private let tabs = ["Pending", "Submitted", "Graded"]

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    LoadingView(message: "Loading assignments...")
                } else {
                    assignmentsContent
                }
            }
            .navigationTitle("Assignments")
            .navigationBarTitleDisplayMode(.large)
            .task { await viewModel.fetchAssignments() }
            .refreshable { await viewModel.fetchAssignments() }
        }
        .navigationViewStyle(.stack)
    }

    private var assignmentsContent: some View {
        VStack(spacing: 0) {
            // Tab selector
            Picker("Filter", selection: $selectedTab) {
                ForEach(0..<tabs.count, id: \.self) { i in
                    Text(tabs[i]).tag(i)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            ScrollView {
                LazyVStack(spacing: 12) {
                    let list: [Assignment] = {
                        switch selectedTab {
                        case 0: return viewModel.pending
                        case 1: return viewModel.submitted
                        case 2: return viewModel.graded
                        default: return []
                        }
                    }()

                    if list.isEmpty {
                        emptyState
                    } else {
                        ForEach(list) { assignment in
                            NavigationLink {
                                AssignmentDetailView(assignment: assignment)
                            } label: {
                                AssignmentCard(assignment: assignment)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.green.opacity(0.5))
            Text("Nothing here!")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

// MARK: - AssignmentCard
struct AssignmentCard: View {
    let assignment: Assignment

    var statusColor: Color {
        switch assignment.status {
        case .pending: return assignment.isOverdue ? .red : .orange
        case .submitted: return .blue
        case .graded: return .green
        case .late: return .red
        case .missing: return .red
        }
    }

    var dueLabel: String {
        let days = assignment.daysUntilDue
        if days < 0 { return "Overdue" }
        if days == 0 { return "Due today" }
        if days == 1 { return "Due tomorrow" }
        return "Due in \(days) days"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(assignment.courseName)
                    .font(.caption.bold())
                    .foregroundColor(.blue)
                Spacer()
                StatusBadge(text: assignment.status.rawValue, color: statusColor)
            }

            Text(assignment.title)
                .font(.subheadline.bold())
                .foregroundColor(.primary)
                .lineLimit(2)

            HStack {
                Label(dueLabel, systemImage: "clock.fill")
                    .font(.caption)
                    .foregroundColor(assignment.isOverdue ? .red : .secondary)
                Spacer()
                Text("\(Int(assignment.maxPoints)) pts")
                    .font(.caption)
                    .foregroundColor(.secondary)

                if let earned = assignment.earnedPoints {
                    Text("· \(Int(earned))/\(Int(assignment.maxPoints))")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                }
            }
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - AssignmentDetailView
struct AssignmentDetailView: View {
    let assignment: Assignment

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(assignment.courseName)
                        .font(.caption.bold())
                        .foregroundColor(.blue)
                    Text(assignment.title)
                        .font(.title2.bold())
                    HStack {
                        StatusBadge(text: assignment.status.rawValue, color: .orange)
                        Spacer()
                        Text("\(Int(assignment.maxPoints)) points")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                // Due Date
                VStack(alignment: .leading, spacing: 6) {
                    Label("Due Date", systemImage: "calendar")
                        .font(.headline)
                    Text(assignment.dueDate, style: .date)
                        .font(.body)
                        .foregroundColor(.secondary)
                    Text(assignment.dueDate, style: .time)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                // Description
                VStack(alignment: .leading, spacing: 6) {
                    Label("Instructions", systemImage: "text.alignleft")
                        .font(.headline)
                    Text(assignment.description)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                // Grade (if graded)
                if let earned = assignment.earnedPoints {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Grade", systemImage: "chart.bar.fill")
                            .font(.headline)
                        Text("\(Int(earned)) / \(Int(assignment.maxPoints))")
                            .font(.title.bold())
                            .foregroundColor(.green)
                        Text(String(format: "%.1f%%", earned / assignment.maxPoints * 100))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Assignment")
        .navigationBarTitleDisplayMode(.inline)
    }
}
