import Foundation

struct Note: Codable, Identifiable {
    let id: String
    var title: String
    var content: String
    var subjectID: String?
    var subjectName: String?
    var createdAt: Date
    var updatedAt: Date
    var isPinned: Bool
    
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: updatedAt, relativeTo: Date())
    }
    
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
    
    var formattedUpdatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: updatedAt)
    }
    
    var contentPreview: String {
        let maxLength = 120
        if content.count <= maxLength { return content }
        return String(content.prefix(maxLength)) + "..."
    }
}

extension Note {
    static let samples: [Note] = [
        Note(
            id: "NOTE-001",
            title: "HTML5 Semantic Elements",
            content: "HTML5 introduced several semantic elements that clearly describe their meaning:\n\n• <header> - Defines a header for a document or section\n• <nav> - Defines navigation links\n• <main> - Defines the main content\n• <article> - Defines independent content\n• <section> - Defines a section in a document\n• <aside> - Defines content aside from the content\n• <footer> - Defines a footer\n\nUsing semantic elements improves accessibility and SEO. Screen readers can better navigate the page, and search engines can better understand the content structure.",
            subjectID: "SUBJ-001",
            subjectName: "Web Development",
            createdAt: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            updatedAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            isPinned: true
        ),
        Note(
            id: "NOTE-002",
            title: "SwiftUI State Management",
            content: "Key property wrappers in SwiftUI:\n\n@State - For simple value types owned by the view\n@Binding - For passing state to child views\n@StateObject - For reference type objects owned by the view\n@ObservedObject - For reference type objects passed to the view\n@EnvironmentObject - For shared data across the view hierarchy\n@Published - For properties in ObservableObject that trigger view updates\n\nRemember: @StateObject creates the object, @ObservedObject expects it to be passed in.",
            subjectID: "SUBJ-002",
            subjectName: "Mobile App Development",
            createdAt: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            updatedAt: Calendar.current.date(byAdding: .hour, value: -6, to: Date())!,
            isPinned: true
        ),
        Note(
            id: "NOTE-003",
            title: "SQL JOIN Types",
            content: "Different types of SQL JOINs:\n\n1. INNER JOIN - Returns records with matching values in both tables\n2. LEFT JOIN - Returns all records from left table and matched from right\n3. RIGHT JOIN - Returns all records from right table and matched from left\n4. FULL OUTER JOIN - Returns all records when there is a match in either table\n5. CROSS JOIN - Returns Cartesian product of both tables\n6. SELF JOIN - A table joined with itself\n\nExample:\nSELECT students.name, courses.title\nFROM students\nINNER JOIN enrollments ON students.id = enrollments.student_id\nINNER JOIN courses ON enrollments.course_id = courses.id;",
            subjectID: "SUBJ-003",
            subjectName: "Database Management",
            createdAt: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            updatedAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            isPinned: false
        ),
        Note(
            id: "NOTE-004",
            title: "Effective Communication Tips",
            content: "Key principles of purposive communication:\n\n1. Know your audience - Tailor your message\n2. Be clear and concise - Avoid jargon\n3. Use active voice - More direct and engaging\n4. Organize your thoughts - Use outlines\n5. Listen actively - Communication is two-way\n6. Non-verbal cues matter - Body language, tone\n7. Provide context - Help others understand\n8. Seek feedback - Ensure understanding\n\nFor academic writing: Always cite sources, maintain formal tone, and follow the required format (APA, MLA, etc.).",
            subjectID: "SUBJ-004",
            subjectName: "Purposive Communication",
            createdAt: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            updatedAt: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
            isPinned: false
        ),
        Note(
            id: "NOTE-005",
            title: "OSI Model Layers",
            content: "The 7 layers of the OSI Model (top to bottom):\n\n7. Application Layer - HTTP, FTP, SMTP\n6. Presentation Layer - Encryption, compression\n5. Session Layer - Session management\n4. Transport Layer - TCP, UDP\n3. Network Layer - IP, routing\n2. Data Link Layer - MAC addresses, switches\n1. Physical Layer - Cables, signals\n\nMnemonic: All People Seem To Need Data Processing\n\nKey difference between TCP and UDP:\n- TCP: Reliable, connection-oriented, slower\n- UDP: Unreliable, connectionless, faster",
            subjectID: "SUBJ-005",
            subjectName: "Networking Fundamentals",
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            updatedAt: Calendar.current.date(byAdding: .hour, value: -3, to: Date())!,
            isPinned: false
        )
    ]
}
