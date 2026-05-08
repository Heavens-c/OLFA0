import SwiftUI

struct LaunchScreenView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    @State private var rotation: Double = -10
    
    var body: some View {
        ZStack {
            AppTheme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 140, height: 140)
                    
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 110, height: 110)
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(rotation))
                }
                .scaleEffect(scale)
                
                VStack(spacing: 8) {
                    Text("OLFU Portal")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Your Academic Companion")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .opacity(opacity)
                
                ProgressView()
                    .tint(.white)
                    .scaleEffect(0.8)
                    .padding(.top, 20)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                rotation = 0
            }
            withAnimation(.easeIn(duration: 0.6).delay(0.3)) {
                opacity = 1.0
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
