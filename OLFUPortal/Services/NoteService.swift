import Foundation

protocol NoteServiceProtocol {
    func fetchNotes() async throws -> [Note]
    func saveNote(_ note: Note) async throws
    func deleteNote(id: String) async throws
    func updateNote(_ note: Note) async throws
}

final class NoteService: NoteServiceProtocol {
    static let shared = NoteService()
    
    private let storageKey = "savedNotes"
    
    private init() {
        if loadNotes().isEmpty {
            saveNotes(Note.samples)
        }
    }
    
    func fetchNotes() async throws -> [Note] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return loadNotes().sorted { $0.updatedAt > $1.updatedAt }
    }
    
    func saveNote(_ note: Note) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        var notes = loadNotes()
        notes.append(note)
        saveNotes(notes)
    }
    
    func deleteNote(id: String) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        var notes = loadNotes()
        notes.removeAll { $0.id == id }
        saveNotes(notes)
    }
    
    func updateNote(_ note: Note) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        var notes = loadNotes()
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveNotes(notes)
        }
    }
    
    // MARK: - Local Persistence
    
    private func loadNotes() -> [Note] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return [] }
        return (try? JSONDecoder().decode([Note].self, from: data)) ?? []
    }
    
    private func saveNotes(_ notes: [Note]) {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
