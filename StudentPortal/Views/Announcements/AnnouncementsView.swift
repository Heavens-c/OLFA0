import SwiftUI

// MARK: - AnnouncementsView
struct AnnouncementsView: View {
    @EnvironmentObject var viewModel: AnnouncementsViewModel
    @State private var selectedCategory: Announcement.AnnouncementCategory?

    var filteredAnnouncements: [Announcement] {
        guard let cat = selectedCategory else { return viewModel.announcements }
        return viewModel.announcements.filter { $0.category == cat }
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    LoadingView(message: "Loading announcements...")
                } else {
                    announcementsContent
                }
            }
            .navigationTitle("Announcements")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if viewModel.unreadCount > 0 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Mark All Read") {
                            viewModel.markAllAsRead()
                        }
                        .font(.caption)
                    }
                }
            }
            .task { await viewModel.fetchAnnouncements() }
            .refreshable { await viewModel.fetchAnnouncements() }
        }
        .navigationViewStyle(.stack)
    }

    private var announcementsContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Category Filter
                categoryFilter

                // List
                LazyVStack(spacing: 12) {
                    ForEach(filteredAnnouncements) { announcement in
                        NavigationLink {
                            AnnouncementDetailView(announcement: announcement)
                                .onAppear { viewModel.markAsRead(announcement) }
                        } label: {
                            AnnouncementRow(announcement: announcement)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(Announcement.AnnouncementCategory.allCases, id: \.self) { cat in
                    FilterChip(label: cat.rawValue, isSelected: selectedCategory == cat) {
                        selectedCategory = selectedCategory == cat ? nil : cat
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - AnnouncementRow
struct AnnouncementRow: View {
    let announcement: Announcement

    var categoryColor: Color {
        switch announcement.category {
        case .general: return .blue
        case .academic: return .purple
        case .events: return .green
        case .emergency: return .red
        case .financial: return .orange
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: announcement.category.iconName)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(categoryColor)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(announcement.title)
                        .font(.subheadline.bold())
                        .lineLimit(1)
                    if !announcement.isRead {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                    }
                }
                Text(announcement.body)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                HStack {
                    Text(announcement.author)
                        .font(.caption2)
                        .foregroundColor(categoryColor)
                    Spacer()
                    Text(announcement.datePosted, style: .relative)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(announcement.isRead ? Color(.secondarySystemBackground) : Color.blue.opacity(0.06))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(announcement.isRead ? Color.clear : Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - AnnouncementDetailView
struct AnnouncementDetailView: View {
    let announcement: Announcement

    var categoryColor: Color {
        switch announcement.category {
        case .general: return .blue
        case .academic: return .purple
        case .events: return .green
        case .emergency: return .red
        case .financial: return .orange
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack(spacing: 14) {
                    Image(systemName: announcement.category.iconName)
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .background(categoryColor)
                        .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(announcement.category.rawValue)
                            .font(.caption.bold())
                            .foregroundColor(categoryColor)
                        Text(announcement.title)
                            .font(.headline)
                    }
                }

                // Meta
                VStack(alignment: .leading, spacing: 6) {
                    DetailRow(label: "From", value: announcement.author)
                    DetailRow(label: "Posted", value: announcement.datePosted.formatted(date: .long, time: .shortened))
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                // Body
                VStack(alignment: .leading, spacing: 8) {
                    Label("Message", systemImage: "text.alignleft")
                        .font(.headline)
                    Text(announcement.body)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Announcement")
        .navigationBarTitleDisplayMode(.inline)
    }
}
