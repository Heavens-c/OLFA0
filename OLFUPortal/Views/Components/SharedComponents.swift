import SwiftUI

struct LoadingView: View {
    var message: String = "Loading..."
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(AppTheme.primaryGreen)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var buttonTitle: String?
    var action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(AppTheme.lightGreen.opacity(0.6))
            
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(AppTheme.darkText)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            if let buttonTitle = buttonTitle, let action = action {
                Button(action: action) {
                    Text(buttonTitle)
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppTheme.primaryGreen)
                        .clipShape(Capsule())
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct ErrorBanner: View {
    let message: String
    var onDismiss: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(AppTheme.error)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppTheme.darkText)
            
            Spacer()
            
            if let onDismiss = onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }
        }
        .padding()
        .background(AppTheme.error.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
        .padding(.horizontal)
    }
}

struct SectionHeader: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(AppTheme.darkText)
            
            Spacer()
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.subheadline.bold())
                        .foregroundStyle(AppTheme.primaryGreen)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct GreenButton: View {
    let title: String
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.8)
                }
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isDisabled ? AppTheme.lightGreen.opacity(0.5) : AppTheme.primaryGreen
            )
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
        }
        .disabled(isDisabled || isLoading)
    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search..."
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppTheme.secondaryText)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
        .padding(.horizontal)
    }
}

struct ProfileAvatar: View {
    var name: String
    var size: CGFloat = 48
    var imageURL: String? = nil
    
    private var initials: String {
        let parts = name.split(separator: " ")
        let firstInitial = parts.first.map { String($0.prefix(1)) } ?? ""
        let lastInitial = parts.count > 1 ? String(parts.last!.prefix(1)) : ""
        return (firstInitial + lastInitial).uppercased()
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(AppTheme.primaryGradient)
                .frame(width: size, height: size)
            
            Text(initials)
                .font(.system(size: size * 0.35, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

struct SubjectBadge: View {
    let colorHex: String
    let code: String
    
    var body: some View {
        Text(code)
            .font(.caption2.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(hex: colorHex))
            .clipShape(Capsule())
    }
}
