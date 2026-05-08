import SwiftUI

struct AppTheme {
    // MARK: - Primary Colors (OLFU Green)
    static let primaryGreen = Color(hex: "#1B5E20")
    static let secondaryGreen = Color(hex: "#2E7D32")
    static let lightGreen = Color(hex: "#4CAF50")
    static let accentGreen = Color(hex: "#66BB6A")
    static let paleGreen = Color(hex: "#E8F5E9")
    
    // MARK: - Neutral Colors
    static let darkText = Color(hex: "#1A1A2E")
    static let secondaryText = Color(hex: "#6B7280")
    static let lightText = Color(hex: "#9CA3AF")
    static let divider = Color(hex: "#E5E7EB")
    static let background = Color(hex: "#F8FAF8")
    static let cardBackground = Color(hex: "#FFFFFF")
    
    // MARK: - Accent Colors
    static let accentBlue = Color(hex: "#1565C0")
    static let accentOrange = Color(hex: "#E65100")
    static let accentPurple = Color(hex: "#6A1B9A")
    static let accentPink = Color(hex: "#AD1457")
    static let accentTeal = Color(hex: "#00838F")
    
    // MARK: - Status Colors
    static let success = Color(hex: "#2E7D32")
    static let warning = Color(hex: "#F57F17")
    static let error = Color(hex: "#C62828")
    static let info = Color(hex: "#1565C0")
    
    // MARK: - Gradients
    static let primaryGradient = LinearGradient(
        colors: [primaryGreen, secondaryGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let headerGradient = LinearGradient(
        colors: [primaryGreen, lightGreen],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.white, paleGreen.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Shadows
    static let cardShadow = Color.black.opacity(0.06)
    static let elevatedShadow = Color.black.opacity(0.12)
    
    // MARK: - Corner Radius
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 16
    static let cornerRadiusXL: CGFloat = 20
    
    // MARK: - Spacing
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 16
    static let spacingLG: CGFloat = 24
    static let spacingXL: CGFloat = 32
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Adaptive Colors
extension AppTheme {
    struct Adaptive {
        static func cardBackground(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color(hex: "#1E1E1E") : .white
        }
        
        static func background(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color(hex: "#121212") : AppTheme.background
        }
        
        static func primaryText(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? .white : AppTheme.darkText
        }
        
        static func secondaryText(_ colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color(hex: "#9CA3AF") : AppTheme.secondaryText
        }
    }
}
