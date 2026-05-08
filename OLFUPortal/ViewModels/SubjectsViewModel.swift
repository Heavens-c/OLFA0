import Foundation
import Combine

@MainActor
final class SubjectsViewModel: ObservableObject {
    @Published var subjects: [Subject] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let service: SubjectServiceProtocol
    
    init(service: SubjectServiceProtocol = SubjectService.shared) {
        self.service = service
    }
    
    var filteredSubjects: [Subject] {
        if searchText.isEmpty { return subjects }
        return subjects.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.code.localizedCaseInsensitiveContains(searchText) ||
            $0.instructor.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var totalUnits: Int {
        subjects.reduce(0) { $0 + $1.units }
    }
    
    func loadSubjects() async {
        isLoading = true
        errorMessage = nil
        
        do {
            subjects = try await service.fetchSubjects()
        } catch let error as APIError {
            errorMessage = error.message
        } catch {
            errorMessage = "Failed to load subjects."
        }
        
        isLoading = false
    }
}
