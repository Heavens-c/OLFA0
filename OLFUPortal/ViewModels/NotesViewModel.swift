import Foundation
import Combine

@MainActor
final class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var showDeleteConfirmation = false
    @Published var noteToDelete: Note?
    
    private let service: NoteServiceProtocol
    
    init(service: NoteServiceProtocol = NoteService.shared) {
        self.service = service
    }
    
    var filteredNotes: [Note] {
        let sorted = notes.sorted { lhs, rhs in
            if lhs.isPinned != rhs.isPinned { return lhs.isPinned }
            return lhs.updatedAt > rhs.updatedAt
        }
        
        if searchText.isEmpty { return sorted }
        return sorted.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText) ||
            ($0.subjectName?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    func loadNotes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            notes = try await service.fetchNotes()
        } catch {
            errorMessage = "Failed to load notes."
        }
        
        isLoading = false
    }
    
    func addNote(title: String, content: String, subjectID: String?, subjectName: String?) async {
        let note = Note(
            id: "NOTE-\(UUID().uuidString.prefix(8))",
            title: title,
            content: content,
            subjectID: subjectID,
            subjectName: subjectName,
            createdAt: Date(),
            updatedAt: Date(),
            isPinned: false
        )
        
        do {
            try await service.saveNote(note)
            await loadNotes()
        } catch {
            errorMessage = "Failed to save note."
        }
    }
    
    func updateNote(_ note: Note) async {
        var updated = note
        updated.updatedAt = Date()
        
        do {
            try await service.updateNote(updated)
            await loadNotes()
        } catch {
            errorMessage = "Failed to update note."
        }
    }
    
    func deleteNote(_ note: Note) async {
        do {
            try await service.deleteNote(id: note.id)
            await loadNotes()
        } catch {
            errorMessage = "Failed to delete note."
        }
    }
    
    func togglePin(_ note: Note) async {
        var updated = note
        updated.isPinned.toggle()
        updated.updatedAt = Date()
        
        do {
            try await service.updateNote(updated)
            await loadNotes()
        } catch {
            errorMessage = "Failed to update note."
        }
    }
    
    func confirmDelete(_ note: Note) {
        noteToDelete = note
        showDeleteConfirmation = true
    }
    
    func executeDelete() async {
        guard let note = noteToDelete else { return }
        await deleteNote(note)
        noteToDelete = nil
    }
}
