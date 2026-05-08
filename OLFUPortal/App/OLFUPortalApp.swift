import SwiftUI

@main
struct OLFUPortalApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .preferredColorScheme(authViewModel.prefersDarkMode ? .dark : nil)
        }
    }
}
