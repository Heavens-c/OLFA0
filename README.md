# 🎓 OLFU Portal (OLP)

A modern iOS Student Portal application built with SwiftUI and MVVM architecture for Our Lady of Fatima University students.

## 📱 Features

### 🔐 User Login & Registration
- Secure email/password authentication
- Input validation with real-time feedback
- Remember Me functionality with session persistence
- Mock API layer (Firebase-ready architecture)

### 📚 Subject Viewer
- View all enrolled subjects with detailed cards
- Subject details with instructor, room, units, and schedule
- Search and filter subjects
- Pull-to-refresh support

### 📝 Notes Management
- Full CRUD: Create, Read, Update, Delete notes
- Attach notes to specific subjects
- Pin important notes
- Search across all notes
- Local persistence via UserDefaults

### 📅 Schedule Viewer
- Weekly and Daily view modes
- Timeline-based daily schedule
- Color-coded subjects
- Current class highlight with live indicator
- Day selector with today marker

### 👤 User Profile
- Student information display
- Edit profile (name, phone, address)
- Change password UI
- Dark mode toggle
- Sign out functionality

## 🏗️ Architecture

```
MVVM (Model-View-ViewModel)
├── Models      → Data structures (Codable)
├── Views       → SwiftUI views (presentation)
├── ViewModels  → Business logic (ObservableObject)
└── Services    → Data access layer (protocols)
```

## 📁 Project Structure

```
OLFUPortal/
├── App/
│   ├── OLFUPortalApp.swift
│   ├── RootView.swift
│   └── MainTabView.swift
├── Models/
│   ├── User.swift
│   ├── Subject.swift
│   ├── Note.swift
│   ├── ScheduleItem.swift
│   └── AuthModels.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── DashboardViewModel.swift
│   ├── SubjectsViewModel.swift
│   ├── NotesViewModel.swift
│   └── ScheduleViewModel.swift
├── Views/
│   ├── Authentication/
│   │   ├── LoginView.swift
│   │   └── RegistrationView.swift
│   ├── Dashboard/
│   │   └── DashboardView.swift
│   ├── Subjects/
│   │   ├── SubjectsListView.swift
│   │   └── SubjectDetailView.swift
│   ├── Notes/
│   │   ├── NotesListView.swift
│   │   ├── NoteDetailView.swift
│   │   └── NoteEditorView.swift
│   ├── Schedule/
│   │   └── ScheduleView.swift
│   ├── Profile/
│   │   ├── ProfileView.swift
│   │   ├── EditProfileView.swift
│   │   └── ChangePasswordView.swift
│   └── Components/
│       ├── SharedComponents.swift
│       └── LaunchScreenView.swift
├── Services/
│   ├── AuthService.swift
│   ├── SubjectService.swift
│   ├── NoteService.swift
│   └── ScheduleService.swift
├── Utilities/
│   ├── AppTheme.swift
│   ├── Validators.swift
│   └── ViewModifiers.swift
├── Resources/
│   └── MockData.json
├── Assets.xcassets/
│   ├── AccentColor.colorset/
│   └── AppIcon.appiconset/
└── Preview Content/
```

## 🛠️ Technical Stack

| Technology | Usage |
|------------|-------|
| SwiftUI | UI Framework |
| Combine | Reactive data binding |
| Async/Await | Asynchronous operations |
| MVVM | Architecture pattern |
| UserDefaults | Local data persistence |
| Codable | JSON serialization |
| NavigationView | Navigation (iOS 15+) |

## ⚙️ Requirements

- **Xcode**: 14.0 or later
- **iOS**: 15.0 or later
- **Swift**: 5.7 or later
- **macOS**: Monterey 12.0 or later (for development)

## 🚀 Setup Instructions

### 1. Clone or Download
```bash
git clone <repository-url>
cd OLFA
```

### 2. Open in Xcode
**Option A — Xcode Project (Recommended):**
1. Open Xcode
2. Select **File → New → Project**
3. Choose **iOS → App**
4. Set product name to `OLFUPortal`
5. Set interface to **SwiftUI**, language to **Swift**
6. Delete the auto-generated files
7. Drag the `OLFUPortal/` folder into the project navigator
8. Ensure all `.swift` files are added to the target

**Option B — Swift Package:**
1. Open `Package.swift` in Xcode
2. The project will resolve automatically

### 3. Configure Target
- Set **Minimum Deployment Target** to iOS 15.0
- Set **Bundle Identifier** to `edu.olfu.portal`

### 4. Build & Run
- Select an iPhone simulator (iPhone 15 Pro recommended)
- Press `⌘R` to build and run

## 🧪 Testing

### Demo Credentials
| Field | Value |
|-------|-------|
| Email | `student@olfu.edu.ph` |
| Password | `password123` |

Alternative: `juan.delacruz@olfu.edu.ph` / `password123`

### Manual Testing Checklist
- [ ] Login with valid credentials
- [ ] Login with invalid credentials (verify error)
- [ ] Register new account
- [ ] Navigate all 5 tabs
- [ ] View subject details
- [ ] Create, edit, pin, and delete notes
- [ ] Switch schedule between weekly/daily view
- [ ] Edit profile information
- [ ] Toggle dark mode
- [ ] Sign out and verify session cleared

## 🎨 Design System

**Color Palette (OLFU Green):**
- Primary: `#1B5E20`
- Secondary: `#2E7D32`
- Light: `#4CAF50`
- Accent: `#66BB6A`
- Pale: `#E8F5E9`

**Typography:** System default (SF Pro)

**Components:** Cards, badges, avatars, search bars, loading states, empty states, error banners

## 📦 Dependencies

**None** — This project uses only Apple's first-party frameworks:
- SwiftUI
- Foundation
- Combine
- UIKit (minimal, for shape helpers)

## 🔮 Future Enhancements

- Firebase Authentication integration
- CloudKit or Firestore for remote data sync
- Push notifications for class reminders
- Grade tracker module
- Attendance tracking
- Academic calendar view
- Offline mode with CoreData

## 📄 License

This project is for educational purposes. © 2026 OLFU Portal Project.
