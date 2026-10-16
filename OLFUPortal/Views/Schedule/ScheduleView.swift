import SwiftUI

struct ScheduleView: View {
    @StateObject private var viewModel = ScheduleViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.isLoading && viewModel.allScheduleItems.isEmpty {
                    LoadingView(message: "Loading schedule...")
                } else {
                    VStack(spacing: 0) {
                        // View mode picker
                        Picker("View Mode", selection: $viewModel.viewMode) {
                            ForEach(ScheduleViewModel.ScheduleViewMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        
                        if viewModel.viewMode == .weekly {
                            weeklyView
                        } else {
                            dailyView
                        }
                    }
                }
            }
            .background(AppTheme.Adaptive.background(colorScheme))
            .navigationTitle("Schedule")
            .task {
                await viewModel.loadSchedule()
            }
        }
    }
    
    // MARK: - Weekly View
    
    private var weeklyView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(viewModel.groupedByDay, id: \.0) { day, items in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(day.rawValue)
                                .font(.headline)
                            
                            if day == DayOfWeek.today {
                                Text("TODAY")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(AppTheme.primaryGreen)
                                    .clipShape(Capsule())
                            }
                            
                            Spacer()
                            
                            Text("\(items.count) class\(items.count == 1 ? "" : "es")")
                                .font(.caption)
                                .foregroundStyle(AppTheme.secondaryText)
                        }
                        
                        ForEach(items) { item in
                            ScheduleItemCard(item: item)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Daily View
    
    private var dailyView: some View {
        VStack(spacing: 0) {
            // Day selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(DayOfWeek.weekdays, id: \.self) { day in
                        DayChip(
                            day: day,
                            isSelected: viewModel.selectedDay == day,
                            isToday: day == DayOfWeek.today
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.selectedDay = day
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            // Schedule for selected day
            ScrollView(showsIndicators: false) {
                if viewModel.scheduleForSelectedDay.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.orange.opacity(0.6))
                        
                        Text("No classes on \(viewModel.selectedDay.rawValue)")
                            .font(.headline)
                        
                        Text("Enjoy your free day!")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                } else {
                    // Timeline view
                    VStack(spacing: 0) {
                        ForEach(Array(viewModel.scheduleForSelectedDay.enumerated()), id: \.element.id) { index, item in
                            HStack(alignment: .top, spacing: 16) {
                                // Time column
                                VStack(spacing: 4) {
                                    Text(formatTime(item.startTime))
                                        .font(.caption.bold())
                                        .foregroundStyle(item.isCurrentlyOngoing ? AppTheme.primaryGreen : AppTheme.secondaryText)
                                    
                                    Text(formatTime(item.endTime))
                                        .font(.caption2)
                                        .foregroundStyle(AppTheme.lightText)
                                }
                                .frame(width: 55)
                                
                                // Timeline dot and line
                                VStack(spacing: 0) {
                                    Circle()
                                        .fill(item.isCurrentlyOngoing ? AppTheme.primaryGreen : Color(hex: item.colorHex))
                                        .frame(width: 12, height: 12)
                                    
                                    if index < viewModel.scheduleForSelectedDay.count - 1 {
                                        Rectangle()
                                            .fill(AppTheme.divider)
                                            .frame(width: 2)
                                            .frame(maxHeight: .infinity)
                                    }
                                }
                                
                                // Card
                                ScheduleItemCard(item: item)
                            }
                            .padding(.bottom, 12)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private func formatTime(_ time: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let date = formatter.date(from: time) else { return time }
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

// MARK: - Schedule Item Card

struct ScheduleItemCard: View {
    let item: ScheduleItem
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(hex: item.colorHex))
                .frame(width: 5)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(item.subjectCode)
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(hex: item.colorHex))
                        .clipShape(Capsule())
                    
                    if item.isCurrentlyOngoing {
                        HStack(spacing: 3) {
                            Circle()
                                .fill(.green)
                                .frame(width: 6, height: 6)
                            Text("NOW")
                                .font(.caption2.bold())
                                .foregroundStyle(.green)
                        }
                    }
                    
                    Spacer()
                }
                
                Text(item.subjectName)
                    .font(.subheadline.bold())
                    .foregroundStyle(AppTheme.Adaptive.primaryText(colorScheme))
                
                HStack(spacing: 14) {
                    Label(item.formattedTime, systemImage: "clock")
                    Label(item.room, systemImage: "mappin")
                    Label(item.instructor, systemImage: "person")
                        .lineLimit(1)
                }
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                .fill(AppTheme.Adaptive.cardBackground(colorScheme))
                .overlay(
                    item.isCurrentlyOngoing ?
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                        .stroke(AppTheme.lightGreen.opacity(0.4), lineWidth: 1.5) :
                    nil
                )
        )
        .shadow(color: AppTheme.cardShadow, radius: 4, y: 2)
    }
}

// MARK: - Day Chip

struct DayChip: View {
    let day: DayOfWeek
    let isSelected: Bool
    let isToday: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(day.shortName)
                    .font(.caption.bold())
                
                if isToday {
                    Circle()
                        .fill(isSelected ? .white : AppTheme.primaryGreen)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(width: 52, height: 52)
            .background(
                isSelected ? AppTheme.primaryGreen : Color(.systemGray6)
            )
            .foregroundStyle(isSelected ? .white : AppTheme.darkText)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium))
        }
    }
}

#Preview {
    ScheduleView()
}
