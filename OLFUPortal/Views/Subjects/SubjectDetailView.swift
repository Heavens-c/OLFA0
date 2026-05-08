import SwiftUI

struct SubjectDetailView: View {
    let subject: Subject
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .bottomLeading) {
                    subject.color
                        .frame(height: 180)
                        .overlay(
                            VStack {
                                Circle()
                                    .fill(.white.opacity(0.08))
                                    .frame(width: 150, height: 150)
                                    .offset(x: 100, y: -30)
                                Spacer()
                            }
                        )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(subject.code)
                            .font(.subheadline.bold())
                            .foregroundStyle(.white.opacity(0.9))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.white.opacity(0.2))
                            .clipShape(Capsule())
                        
                        Text(subject.name)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }
                    .padding(20)
                }
                
                VStack(spacing: 20) {
                    // Info cards
                    VStack(spacing: 12) {
                        DetailRow(icon: "person.fill", title: "Instructor", value: subject.instructor, color: subject.color)
                        DetailRow(icon: "mappin.circle.fill", title: "Room", value: subject.room, color: subject.color)
                        DetailRow(icon: "number.circle.fill", title: "Units", value: "\(subject.units)", color: subject.color)
                        DetailRow(icon: "clock.fill", title: "Schedule", value: subject.schedule, color: subject.color)
                        DetailRow(icon: "calendar", title: "Days", value: subject.day, color: subject.color)
                    }
                    .padding()
                    .background(AppTheme.Adaptive.cardBackground(colorScheme))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge))
                    .shadow(color: AppTheme.cardShadow, radius: 6, y: 3)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "doc.text.fill")
                                .foregroundStyle(subject.color)
                            Text("Description")
                                .font(.headline)
                        }
                        
                        Text(subject.description)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondaryText)
                            .lineSpacing(4)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.Adaptive.cardBackground(colorScheme))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge))
                    .shadow(color: AppTheme.cardShadow, radius: 6, y: 3)
                    
                    // Schedule Preview
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundStyle(subject.color)
                            Text("Schedule Preview")
                                .font(.headline)
                        }
                        
                        let scheduleItems = ScheduleItem.samples.filter { $0.subjectID == subject.id }
                        
                        ForEach(scheduleItems) { item in
                            HStack {
                                Text(item.day.rawValue)
                                    .font(.subheadline.bold())
                                    .frame(width: 90, alignment: .leading)
                                
                                Text(item.formattedTime)
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.secondaryText)
                                
                                Spacer()
                                
                                Text(item.room)
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.secondaryText)
                            }
                            .padding(.vertical, 4)
                            
                            if item.id != scheduleItems.last?.id {
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.Adaptive.cardBackground(colorScheme))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusLarge))
                    .shadow(color: AppTheme.cardShadow, radius: 6, y: 3)
                }
                .padding(20)
            }
        }
        .background(AppTheme.Adaptive.background(colorScheme))
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                
                Text(value)
                    .font(.subheadline.bold())
            }
            
            Spacer()
        }
    }
}
