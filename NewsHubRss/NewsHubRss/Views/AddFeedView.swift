//
//  AddFeedView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 26.02.23.
//

import SwiftUI

struct AddFeedView: View {
    @State private var feedUrl = ""
    @State private var isLoading = false
    @State private var hasError = false
    @State private var errorText = ""

    var body: some View {
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

            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .navigationTitle(L10n.AddNewFeed.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func startScanningFeed() {
        guard let url = URL(string: feedUrl) else {
            return
        }

        isLoading = true
        hasError = false
        Networking.getRSSPageOfSite(by: url) { result in
            isLoading = false
            switch result {
            case .failure(let error):
                hasError = true
                errorText = error.localizedDescription
                print(error)
            case .success(let htmlDocument):
                print(htmlDocument)
            }
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
