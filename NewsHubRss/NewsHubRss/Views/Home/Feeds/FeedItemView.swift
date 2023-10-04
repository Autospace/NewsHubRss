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
    var hasRead: Bool = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.trimmingCharacters(in: .whitespacesAndNewlines))
                .foregroundColor(hasRead ? .gray : (colorScheme == .dark ? .white : .black))
            Text(getDateString())
                .font(.system(size: 12))
                .foregroundColor(.gray)
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
        FeedItemView(title: "Test title", date: Date())
    }
}
