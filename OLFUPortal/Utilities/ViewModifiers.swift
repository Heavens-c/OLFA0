import SwiftUI

// MARK: - View Modifiers

struct CardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(AppTheme.Adaptive.cardBackground(colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge))
            .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct ElevatedCardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(AppTheme.Adaptive.cardBackground(colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusXL))
            .shadow(color: AppTheme.elevatedShadow, radius: 12, x: 0, y: 6)
    }
}

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [.clear, .white.opacity(0.4), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 300
                }
            }
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
    
    func elevatedCardStyle() -> some View {
        modifier(ElevatedCardModifier())
    }
    
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
