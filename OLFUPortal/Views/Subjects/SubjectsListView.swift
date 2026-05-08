import SwiftUI

struct SubjectsListView: View {
    @StateObject private var viewModel = SubjectsViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.isLoading && viewModel.subjects.isEmpty {
                    LoadingView(message: "Loading subjects...")
                } else if let error = viewModel.errorMessage, viewModel.subjects.isEmpty {
                    EmptyStateView(
                        icon: "exclamationmark.triangle",
                        title: "Failed to Load",
                        message: error,
                        buttonTitle: "Retry"
                    ) {
                        Task { await viewModel.loadSubjects() }
                    }
                } else if viewModel.filteredSubjects.isEmpty && !viewModel.searchText.isEmpty {
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "No Results",
                        message: "No subjects match your search"
                    )
                } else {
                    subjectsList
                }
            }
            .background(AppTheme.Adaptive.background(colorScheme))
            .navigationTitle("Subjects")
            .searchable(text: $viewModel.searchText, prompt: "Search subjects...")
            .refreshable {
                await viewModel.loadSubjects()
            }
            .task {
                await viewModel.loadSubjects()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 4) {
                        Image(systemName: "book.fill")
                            .font(.caption)
                        Text("\(viewModel.totalUnits) units")
                            .font(.caption.bold())
                    }
                    .foregroundStyle(AppTheme.primaryGreen)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppTheme.paleGreen)
                    .clipShape(Capsule())
                }
            }
        }
    }
    
    private var subjectsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredSubjects) { subject in
                    NavigationLink(destination: SubjectDetailView(subject: subject)) {
                        SubjectCardView(subject: subject)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

// MARK: - Subject Card

struct SubjectCardView: View {
    let subject: Subject
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        SubjectBadge(colorHex: subject.colorHex, code: subject.code)
                        
                        Text("\(subject.units) units")
                            .font(.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    
                    Text(subject.name)
                        .font(.headline)
                        .foregroundStyle(AppTheme.Adaptive.primaryText(colorScheme))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(AppTheme.lightText)
                    .padding(.top, 4)
            }
            
            Divider()
            
            HStack(spacing: 16) {
                Label(subject.instructor, systemImage: "person.fill")
                    .lineLimit(1)
                
                Spacer()
                
                Label(subject.room, systemImage: "mappin.circle.fill")
            }
            .font(.caption)
            .foregroundStyle(AppTheme.secondaryText)
            
            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .font(.caption)
                    .foregroundStyle(subject.color)
                
                Text(subject.schedule)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
            }
        }
        .padding(16)
        .background(AppTheme.Adaptive.cardBackground(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge))
        .shadow(color: AppTheme.cardShadow, radius: 6, y: 3)
    }
}

#Preview {
    SubjectsListView()
}
