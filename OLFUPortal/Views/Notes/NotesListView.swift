import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var showAddNote = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.isLoading && viewModel.notes.isEmpty {
                    LoadingView(message: "Loading notes...")
                } else if viewModel.filteredNotes.isEmpty && viewModel.searchText.isEmpty {
                    EmptyStateView(
                        icon: "note.text.badge.plus",
                        title: "No Notes Yet",
                        message: "Start taking notes for your subjects to stay organized",
                        buttonTitle: "Create Note"
                    ) {
                        showAddNote = true
                    }
                } else if viewModel.filteredNotes.isEmpty {
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "No Results",
                        message: "No notes match your search"
                    )
                } else {
                    notesList
                }
            }
            .background(AppTheme.Adaptive.background(colorScheme))
            .navigationTitle("Notes")
            .searchable(text: $viewModel.searchText, prompt: "Search notes...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddNote = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(AppTheme.primaryGreen)
                    }
                }
            }
            .sheet(isPresented: $showAddNote) {
                NoteEditorView(viewModel: viewModel, mode: .add)
            }
            .alert("Delete Note?", isPresented: $viewModel.showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    Task { await viewModel.executeDelete() }
                }
            } message: {
                Text("This action cannot be undone.")
            }
            .task {
                await viewModel.loadNotes()
            }
        }
    }
    
    private var notesList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredNotes) { note in
                    NavigationLink {
                        NoteDetailView(note: note, viewModel: viewModel)
                    } label: {
                        NoteCardView(note: note, viewModel: viewModel)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

// MARK: - Note Card

struct NoteCardView: View {
    let note: Note
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        if note.isPinned {
                            Image(systemName: "pin.fill")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.accentOrange)
                        }
                        
                        Text(note.title)
                            .font(.headline)
                            .lineLimit(1)
                            .foregroundStyle(AppTheme.Adaptive.primaryText(colorScheme))
                    }
                    
                    if let subjectName = note.subjectName {
                        Text(subjectName)
                            .font(.caption)
                            .foregroundStyle(AppTheme.primaryGreen)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(AppTheme.paleGreen)
                            .clipShape(Capsule())
                    }
                }
                
                Spacer()
                
                Menu {
                    Button {
                        Task { await viewModel.togglePin(note) }
                    } label: {
                        Label(
                            note.isPinned ? "Unpin" : "Pin",
                            systemImage: note.isPinned ? "pin.slash" : "pin"
                        )
                    }
                    
                    Button(role: .destructive) {
                        viewModel.confirmDelete(note)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                        .padding(8)
                }
            }
            
            Text(note.contentPreview)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
                .lineLimit(2)
            
            HStack {
                Text(note.formattedDate)
                    .font(.caption2)
                    .foregroundStyle(AppTheme.lightText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(AppTheme.lightText)
            }
        }
        .padding(16)
        .background(AppTheme.Adaptive.cardBackground(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge))
        .shadow(color: AppTheme.cardShadow, radius: 6, y: 3)
    }
}

#Preview {
    NotesListView()
}
