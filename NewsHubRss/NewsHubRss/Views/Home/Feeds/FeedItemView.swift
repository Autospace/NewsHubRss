//
//  FeedItemView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 17.04.23.
//

import SwiftUI

struct FeedItemView: View {
    let title: String
    let date: Date
    let imageUrl: URL?
    var hasRead: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    let imageWidth: CGFloat = 65
    let imageHeight: CGFloat = 65
    @AppStorage(AppSettings.showImagesForFeedItemsInTheList.rawValue) var showImagesForFeedItemsInTheList = true

    var body: some View {
        HStack {
            if showImagesForFeedItemsInTheList {
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
                    .foregroundColor(hasRead ? .gray : (colorScheme == .dark ? .white : .black))
                Text(getDateString())
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
    }

    private func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: date)
    }
}

struct FeedItemView_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemView(title: "Test title", date: Date(), imageUrl: URL(string: "https://picsum.photos/200/200"))
    }
}
