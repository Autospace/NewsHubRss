//
//  AddFeedView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 26.02.23.
//

import SwiftUI
import SwiftSoup

struct AddFeedView: View {
    @State private var feedUrl = ""
    @State private var isLoading = false
    @State private var hasError = false
    @State private var errorText = ""
    @State private var foundRssFeeds: [String] = []

    var body: some View {
        VStack {
            Form {
                Text(L10n.AddNewFeed.instruction)
                TextField(L10n.AddNewFeed.TextField.placeholder, text: $feedUrl)
                    .frame(height: 44)
                    .autocapitalization(.none)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(hasError ? Color.red : Color.gray)
                    )
                    .disableAutocorrection(true)
                    .onChange(of: feedUrl) { _ in
                        hasError = false
                    }

                if hasError {
                    Text(errorText)
                        .listRowSeparator(.hidden)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(0)
                }

                Button(action: startScanningFeed) {
                    HStack {
                        Spacer()
                        Text(L10n.AddNewFeed.scanButtonTitle)
                            .padding(4)
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(feedUrl.count < 3)
                .listRowSeparator(.hidden)
            }

            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }

            List {
                ForEach(foundRssFeeds, id: \.self) { item in
                    Text(item)
                }
            }
            .listStyle(.inset)
        }
        .navigationTitle(L10n.AddNewFeed.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func startScanningFeed() {
        guard let url = URL(string: feedUrl) else {
            return
        }

        foundRssFeeds = []
        isLoading = true
        hasError = false
        Networking.getRSSPageOfSite(by: url) { result in
            switch result {
            case .failure(let error):
                isLoading = false
                hasError = true
                errorText = error.localizedDescription
            case .success(let htmlDocument):
                parseHtmlDocumentToFindRssFeeds(htmlDocument)
            }
        }
    }

    private func parseHtmlDocumentToFindRssFeeds(_ html: String) {
        guard let doc = try? SwiftSoup.parse(html), let elements = try? doc.getAllElements() else {
            hasError = true
            errorText = "Cannot parse received document"
            return
        }

        let group = DispatchGroup()
        for element in elements {
            guard element.hasAttr("href"), var link = try? element.attr("href") else {
                continue
            }

            if let url = URL(string: link), url.host == nil {
                link = feedUrl + link
            }

            guard let url = URL(string: link) else {
                continue
            }

            group.enter()
            Networking.detectRssFeed(by: url) { isRSS in
                group.leave()
                if isRSS {
                    foundRssFeeds.append(url.absoluteString)
                }
            }
        }

        group.notify(queue: .main) {
            isLoading = false
        }
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddFeedView()
        }
    }
}
