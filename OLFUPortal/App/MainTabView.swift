import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    @EnvironmentObject var authViewModel: AuthViewModel
    
    enum TabItem: String, CaseIterable {
        case home = "Home"
        case subjects = "Subjects"
        case notes = "Notes"
        case schedule = "Schedule"
        case profile = "Profile"
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .subjects: return "book.fill"
            case .notes: return "note.text"
            case .schedule: return "calendar"
            case .profile: return "person.fill"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label(TabItem.home.rawValue, systemImage: TabItem.home.icon)
                }
                .tag(TabItem.home)
            
            SubjectsListView()
                .tabItem {
                    Label(TabItem.subjects.rawValue, systemImage: TabItem.subjects.icon)
                }
                .tag(TabItem.subjects)
            
            NotesListView()
                .tabItem {
                    Label(TabItem.notes.rawValue, systemImage: TabItem.notes.icon)
                }
                .tag(TabItem.notes)
            
            ScheduleView()
                .tabItem {
                    Label(TabItem.schedule.rawValue, systemImage: TabItem.schedule.icon)
                }
                .tag(TabItem.schedule)
            
            ProfileView()
                .tabItem {
                    Label(TabItem.profile.rawValue, systemImage: TabItem.profile.icon)
                }
                .tag(TabItem.profile)
        }
        .tint(AppTheme.primaryGreen)
    }
}
