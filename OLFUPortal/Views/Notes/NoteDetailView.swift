import SwiftUI

struct NoteDetailView: View {
    let note: Note
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var showEditor = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        if note.isPinned {
                            HStack(spacing: 4) {
                                Image(systemName: "pin.fill")
                                    .font(.caption2)
                                Text("Pinned")
                                    .font(.caption2.bold())
                            }
                            .foregroundStyle(AppTheme.accentOrange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppTheme.accentOrange.opacity(0.12))
                            .clipShape(Capsule())
                        }
                        
                        if let subjectName = note.subjectName {
                            Text(subjectName)
                                .font(.caption2.bold())
                                .foregroundStyle(AppTheme.primaryGreen)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppTheme.paleGreen)
                                .clipShape(Capsule())
                        }
                        
                        Spacer()
                    }
                    
                    Text(note.title)
                        .font(.title2.bold())
                    
                    HStack(spacing: 16) {
                        Label("Created: \(note.formattedCreatedDate)", systemImage: "calendar")
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                    
                    if note.createdAt != note.updatedAt {
                        Label("Updated: \(note.formattedUpdatedDate)", systemImage: "clock.arrow.circlepath")
                            .font(.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.Adaptive.cardBackground(colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge))
                .shadow(color: AppTheme.cardShadow, radius: 6, y: 3)
                
                // Content
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.text")
                            .foregroundStyle(AppTheme.primaryGreen)
                        Text("Content")
                            .font(.headline)
                    }
                    
                    Text(note.content)
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundStyle(AppTheme.Adaptive.primaryText(colorScheme))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.Adaptive.cardBackground(colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge))
                .shadow(color: AppTheme.cardShadow, radius: 6, y: 3)
            }
            .padding()
        }
        .background(AppTheme.Adaptive.background(colorScheme))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    Button {
                        Task { await viewModel.togglePin(note) }
                    } label: {
                        Image(systemName: note.isPinned ? "pin.slash.fill" : "pin.fill")
                            .foregroundStyle(AppTheme.primaryGreen)
                    }
                    
                    Button {
                        showEditor = true
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundStyle(AppTheme.primaryGreen)
                    }
                    
                    Button {
                        viewModel.confirmDelete(note)
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(AppTheme.error)
                    }
                }
            }
        }
        .sheet(isPresented: $showEditor) {
            NoteEditorView(viewModel: viewModel, mode: .edit(note))
        }
        .alert("Delete Note?", isPresented: $viewModel.showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.executeDelete()
                    dismiss()
                }
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}
