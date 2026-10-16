import SwiftUI

struct NoteEditorView: View {
    @ObservedObject var viewModel: NotesViewModel
    let mode: EditorMode
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedSubjectID: String?
    @State private var selectedSubjectName: String?
    @State private var isSaving = false
    
    enum EditorMode {
        case add
        case edit(Note)
        
        var isEditing: Bool {
            if case .edit = self { return true }
            return false
        }
        
        var navigationTitle: String {
            isEditing ? "Edit Note" : "New Note"
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Title field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.subheadline.bold())
                        
                        TextField("Note title", text: $title)
                            .font(.title3)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
                    }
                    
                    // Subject picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Subject (Optional)")
                            .font(.subheadline.bold())
                        
                        Menu {
                            Button("None") {
                                selectedSubjectID = nil
                                selectedSubjectName = nil
                            }
                            
                            ForEach(Subject.samples) { subject in
                                Button("\(subject.code) - \(subject.name)") {
                                    selectedSubjectID = subject.id
                                    selectedSubjectName = subject.name
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundStyle(AppTheme.secondaryText)
                                
                                Text(selectedSubjectName ?? "Select a subject")
                                    .foregroundStyle(selectedSubjectName != nil ? AppTheme.Adaptive.primaryText(colorScheme) : AppTheme.lightText)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.secondaryText)
                            }
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
                        }
                    }
                    
                    // Content field
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Content")
                                .font(.subheadline.bold())
                            Spacer()
                            Text("\(content.count) characters")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.lightText)
                        }
                        
                        TextEditor(text: $content)
                            .font(.body)
                            .frame(minHeight: 250)
                            .padding(10)
                            .onAppear {
                                UITextView.appearance().backgroundColor = .clear
                            }
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
                    }
                }
                .padding()
            }
            .background(AppTheme.Adaptive.background(colorScheme))
            .navigationTitle(mode.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(AppTheme.secondaryText)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await saveNote() }
                    } label: {
                        if isSaving {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Text("Save")
                                .font(.headline)
                                .foregroundStyle(canSave ? AppTheme.primaryGreen : AppTheme.lightText)
                        }
                    }
                    .disabled(!canSave || isSaving)
                }
            }
            .onAppear {
                if case .edit(let note) = mode {
                    title = note.title
                    content = note.content
                    selectedSubjectID = note.subjectID
                    selectedSubjectName = note.subjectName
                }
            }
        }
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveNote() async {
        isSaving = true
        
        if case .edit(var note) = mode {
            note.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            note.content = content.trimmingCharacters(in: .whitespacesAndNewlines)
            note.subjectID = selectedSubjectID
            note.subjectName = selectedSubjectName
            await viewModel.updateNote(note)
        } else {
            await viewModel.addNote(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                content: content.trimmingCharacters(in: .whitespacesAndNewlines),
                subjectID: selectedSubjectID,
                subjectName: selectedSubjectName
            )
        }
        
        isSaving = false
        dismiss()
    }
}
