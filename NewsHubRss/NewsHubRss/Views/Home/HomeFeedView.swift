import SwiftUI

struct HomeFeedView: View {
    @ObservedObject var feed: DBFeed

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(feed.title)
                    .font(.headline)
                    .padding(.top, 4)
                    .lineLimit(nil)
            }
            .padding()

            if feed.unreadCount > 0 {
                Text("\(L10n.MainPage.HomeFeedView.unread) - \(feed.unreadCount)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(Capsule())
                    .offset(x: 12, y: -12)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    VStack {
        HomeFeedView(feed: DBFeed.previewInstance())
            .frame(maxHeight: 80)
    }
}
