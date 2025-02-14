import SwiftUI

struct FeedItemView: View {
    let title: String
    let date: Date
    let imageUrl: URL?
    @State var hasRead: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage(AppSettings.showImagesForFeedItemsInTheList.rawValue) var showImagesForFeedItemsInTheList = true
    var onTapActionHandler: (() -> Void)?

    private let imageWidth: CGFloat = 65
    private let imageHeight: CGFloat = 65

    var body: some View {
        HStack {
            if showImagesForFeedItemsInTheList && !(imageUrl?.absoluteString ?? "").isEmpty {
                VStack {
                    AsyncImage(
                        url: imageUrl,
                        content: { image in
                            image.resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .frame(maxWidth: imageWidth, maxHeight: imageHeight)
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                    .frame(width: imageWidth, height: imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 4))

                    Spacer()
                }
                .padding(0)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(title.trimmingCharacters(in: .whitespacesAndNewlines))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(hasRead ? .gray : (colorScheme == .dark ? .white : .black))
                Text(getDateString())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            hasRead = true
            onTapActionHandler?()
        }
    }

    private func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: date)
    }
}

#Preview {
    FeedItemView(title: "Test title", date: Date(), imageUrl: URL(string: "https://picsum.photos/200/200"))
}
