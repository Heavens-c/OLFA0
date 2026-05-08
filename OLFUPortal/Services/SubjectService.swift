import Foundation

protocol SubjectServiceProtocol {
    func fetchSubjects() async throws -> [Subject]
    func fetchSubject(id: String) async throws -> Subject
}

final class SubjectService: SubjectServiceProtocol {
    static let shared = SubjectService()
    private init() {}
    
    func fetchSubjects() async throws -> [Subject] {
        try await Task.sleep(nanoseconds: 800_000_000)
        return Subject.samples
    }
    
    func fetchSubject(id: String) async throws -> Subject {
        try await Task.sleep(nanoseconds: 400_000_000)
        guard let subject = Subject.samples.first(where: { $0.id == id }) else {
            throw APIError.notFound
        }
        return subject
    }
}
