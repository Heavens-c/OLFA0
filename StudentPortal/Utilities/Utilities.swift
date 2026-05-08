import Foundation
import SwiftUI

// MARK: - App Constants
enum AppConstants {
    static let appName = "Student Portal"
    static let universityName = "University of Excellence"
    static let supportEmail = "support@university.edu"
    static let academicYear = "2024-2025"

    enum Colors {
        static let primary = Color.blue
        static let secondary = Color.purple
        static let success = Color.green
        static let warning = Color.orange
        static let danger = Color.red
    }

    enum Layout {
        static let cornerRadius: CGFloat = 12
        static let cardPadding: CGFloat = 14
        static let horizontalPadding: CGFloat = 16
    }
}

// MARK: - Date Formatter Extensions
extension DateFormatter {
    static let displayDate: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    static let displayTime: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short
        return f
    }()

    static let shortDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return f
    }()
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self
            .padding(AppConstants.Layout.cardPadding)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(AppConstants.Layout.cornerRadius)
    }

    func primaryButton() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(AppConstants.Layout.cornerRadius)
    }
}

// MARK: - String Extensions
extension String {
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: self)
    }
}
