import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                    
                    VStack(spacing: 24) {
                        quickAccessSection
                        
                        if let currentClass = viewModel.currentClass {
                            currentClassSection(currentClass)
                        }
                        
                        todayClassesSection
                        recentNotesSection
                        subjectOverviewSection
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
            }
            .background(AppTheme.Adaptive.background(colorScheme))
            .ignoresSafeArea(edges: .top)
            .refreshable {
                await viewModel.loadDashboard()
            }
            .task {
                await viewModel.loadDashboard()
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            AppTheme.primaryGradient
                .frame(height: 200)
            
            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 200, height: 200)
                .offset(x: 200, y: -40)
            
            Circle()
                .fill(.white.opacity(0.08))
                .frame(width: 120, height: 120)
                .offset(x: -30, y: 20)
            
            HStack(spacing: 14) {
                ProfileAvatar(
                    name: authViewModel.currentUser?.fullName ?? "Student",
                    size: 52
                )
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.4), lineWidth: 2)
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.greeting + " 👋")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Text(authViewModel.currentUser?.firstName ?? "Student")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    
                    Text(viewModel.todayDateString)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Spacer()
                
                VStack {
                    Spacer()
                    Image(systemName: "bell.badge.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(.white.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .clipShape(RoundedShape(corners: [.bottomLeft, .bottomRight], radius: 24))
    }
    
    // MARK: - Quick Access
    
    private var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Quick Access")
            
            HStack(spacing: 12) {
                QuickAccessCard(
                    icon: "book.fill",
                    title: "Subjects",
                    value: "\(viewModel.subjects.count)",
                    color: AppTheme.accentBlue
                )
                
                QuickAccessCard(
                    icon: "note.text",
                    title: "Notes",
                    value: "\(viewModel.recentNotes.count)",
                    color: AppTheme.accentOrange
                )
                
                QuickAccessCard(
                    icon: "calendar",
                    title: "Today",
                    value: "\(viewModel.todaySchedule.count)",
                    color: AppTheme.accentPurple
                )
                
                QuickAccessCard(
                    icon: "clock.fill",
                    title: "Units",
                    value: "\(viewModel.subjects.reduce(0) { $0 + $1.units })",
                    color: AppTheme.accentTeal
                )
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Current Class
    
    private func currentClassSection(_ item: ScheduleItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Happening Now")
            
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: item.colorHex))
                    .frame(width: 6)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(item.subjectCode)
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(hex: item.colorHex))
                            .clipShape(Capsule())
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(.green)
                                .frame(width: 8, height: 8)
                            Text("LIVE")
                                .font(.caption2.bold())
                                .foregroundStyle(.green)
                        }
                    }
                    
                    Text(item.subjectName)
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        Label(item.room, systemImage: "mappin.circle.fill")
                        Label(item.formattedTime, systemImage: "clock.fill")
                    }
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge)
                    .fill(AppTheme.Adaptive.cardBackground(colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge)
                            .stroke(AppTheme.lightGreen.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(color: AppTheme.cardShadow, radius: 6, y: 3)
            .padding(.horizontal)
        }
    }
    
    // MARK: - Today's Classes
    
    private var todayClassesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Today's Classes")
            
            if viewModel.todaySchedule.isEmpty {
                HStack(spacing: 12) {
                    Image(systemName: "sun.max.fill")
                        .font(.title2)
                        .foregroundStyle(.orange)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("No classes today!")
                            .font(.subheadline.bold())
                        Text("Enjoy your free time")
                            .font(.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    Spacer()
                }
                .padding()
                .cardStyle()
                .padding(.horizontal)
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.todaySchedule) { item in
                        DashboardScheduleCard(item: item)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Recent Notes
    
    private var recentNotesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Recent Notes", actionTitle: "View All") { }
            
            if viewModel.recentNotes.isEmpty {
                HStack(spacing: 12) {
                    Image(systemName: "note.text")
                        .font(.title2)
                        .foregroundStyle(AppTheme.lightGreen)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("No notes yet")
                            .font(.subheadline.bold())
                        Text("Start taking notes for your subjects")
                            .font(.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    Spacer()
                }
                .padding()
                .cardStyle()
                .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.recentNotes) { note in
                            DashboardNoteCard(note: note)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    // MARK: - Subject Overview
    
    private var subjectOverviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Enrolled Subjects")
            
            VStack(spacing: 8) {
                ForEach(viewModel.subjects.prefix(4)) { subject in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(subject.color)
                            .frame(width: 10, height: 10)
                        
                        Text(subject.code)
                            .font(.caption.bold())
                            .foregroundStyle(AppTheme.secondaryText)
                            .frame(width: 65, alignment: .leading)
                        
                        Text(subject.name)
                            .font(.subheadline)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text("\(subject.units) units")
                            .font(.caption)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    
                    if subject.id != viewModel.subjects.prefix(4).last?.id {
                        Divider()
                    }
                }
            }
            .padding()
            .cardStyle()
            .padding(.horizontal)
        }
    }
}

// MARK: - Quick Access Card

struct QuickAccessCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(color)
            }
            
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(AppTheme.Adaptive.primaryText(colorScheme))
            
            Text(title)
                .font(.caption2)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(AppTheme.Adaptive.cardBackground(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
        .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
    }
}

// MARK: - Dashboard Schedule Card

struct DashboardScheduleCard: View {
    let item: ScheduleItem
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: item.colorHex))
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.subjectName)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                
                HStack(spacing: 12) {
                    Label(item.formattedTime, systemImage: "clock")
                    Label(item.room, systemImage: "mappin")
                }
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
            }
            
            Spacer()
            
            Text(item.subjectCode)
                .font(.caption.bold())
                .foregroundStyle(Color(hex: item.colorHex))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(hex: item.colorHex).opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(12)
        .background(AppTheme.Adaptive.cardBackground(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
        .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
    }
}

// MARK: - Dashboard Note Card

struct DashboardNoteCard: View {
    let note: Note
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.accentOrange)
                }
                
                Text(note.title)
                    .font(.subheadline.bold())
                    .lineLimit(1)
            }
            
            Text(note.contentPreview)
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
                .lineLimit(3)
            
            Spacer()
            
            HStack {
                if let subjectName = note.subjectName {
                    Text(subjectName)
                        .font(.caption2)
                        .foregroundStyle(AppTheme.primaryGreen)
                }
                Spacer()
                Text(note.formattedDate)
                    .font(.caption2)
                    .foregroundStyle(AppTheme.lightText)
            }
        }
        .padding(14)
        .frame(width: 200, height: 140, alignment: .topLeading)
        .background(AppTheme.Adaptive.cardBackground(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
        .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthViewModel())
}
