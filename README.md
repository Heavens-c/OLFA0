# Student Portal — iOS App

A student portal mobile application built with **Swift** and **SwiftUI**, developed using **Xcode**.

---

## 📱 Features

| Screen | Description |
|---|---|
| **Login** | Secure sign-in with email & password |
| **Dashboard** | Overview of GPA, today's classes, and upcoming due dates |
| **Courses** | List of enrolled courses with details (instructor, schedule, room) |
| **Grades** | Current semester grades and full transcript with GPA summary |
| **Assignments** | Pending, submitted, and graded assignments with due-date tracking |
| **Schedule** | Day-by-day class schedule view with time and location |
| **Announcements** | University notices with category filtering and unread badge |
| **Profile** | Student info, academic summary, quick resource links, sign-out |

---

## 🏗 Architecture

The app follows the **MVVM (Model–View–ViewModel)** pattern:

```
StudentPortal/
├── App/
│   └── StudentPortalApp.swift       # @main entry point, auth routing
├── Models/
│   └── Models.swift                 # Student, Course, Grade, Assignment, Announcement
├── Services/
│   ├── AuthService.swift            # Login / logout / session persistence
│   └── DataServices.swift           # Course, Grade, Assignment, Announcement services + mock data
├── ViewModels/
│   └── ViewModels.swift             # ObservableObject VMs for each feature
├── Views/
│   ├── Auth/         LoginView.swift
│   ├── Dashboard/    DashboardView.swift  (+ MainTabView)
│   ├── Courses/      CoursesView.swift, CourseDetailView.swift
│   ├── Grades/       GradesView.swift
│   ├── Schedule/     ScheduleView.swift
│   ├── Assignments/  AssignmentsView.swift, AssignmentDetailView.swift
│   ├── Announcements/AnnouncementsView.swift, AnnouncementDetailView.swift
│   ├── Profile/      ProfileView.swift
│   └── Components/   SharedComponents.swift  (reusable UI elements)
├── Utilities/
│   └── Utilities.swift              # Constants, extensions
└── Resources/
    ├── Info.plist
    └── Assets.xcassets
```

---

## 🚀 Getting Started

### Requirements

| Tool | Version |
|---|---|
| Xcode | 15.0+ |
| Swift | 5.9+ |
| iOS Deployment Target | 16.0+ |
| Device / Simulator | iPhone or iPad |

### Running the App

1. **Clone the repository**
   ```bash
   git clone https://github.com/Heavens-c/OLFA0.git
   cd OLFA0
   ```

2. **Open in Xcode**
   ```bash
   open StudentPortal.xcodeproj
   ```

3. **Select a simulator** (e.g. iPhone 15 Pro) in the scheme selector.

4. **Build & Run** — press **⌘R** or click the ▶ button.

### Demo Login

Use these credentials on the Login screen to sign in:

| Field | Value |
|---|---|
| Email | `student@university.edu` |
| Password | `password123` |

> Tap the credential hint text on the login screen to auto-fill them.

---

## 📦 Dependencies

**None** — the project uses only Apple frameworks:

- `SwiftUI` — declarative UI
- `Combine` — reactive data flow
- `Foundation` — data models & networking utilities

No third-party package manager is required.

---

## 🛠 Key Implementation Notes

- **Async/await** used for all service calls (simulated network delays).
- Session persistence via `UserDefaults` (in production, use the Keychain for tokens).
- Mock data seeded in `DataServices.swift` — swap the service implementations with real API calls when connecting to a backend.
- All views support **dark mode** and **dynamic type** out of the box through SwiftUI's adaptive color/font system.

---

## 📄 License

See [LICENSE](LICENSE) for details.
