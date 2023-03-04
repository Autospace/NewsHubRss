//
//  AddFeedView.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 26.02.23.
//

import SwiftUI

struct AddFeedView: View {
    @State private var feedUrl = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text(L10n.AddNewFeed.instruction)
                    TextField(L10n.AddNewFeed.TextField.placeholder, text: $feedUrl)
                        .frame(height: 44)
                        .autocapitalization(.none)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke()
                        )
                }

                HStack {
                    Spacer()

                    Button(L10n.AddNewFeed.buttonTitle) {
                        startScanningFeed()
                    }
                    .frame(width: UIScreen.main.bounds.width / 3, height: 44)
                    .background(Color.yellow)
                    .clipShape(Capsule())
                    .foregroundColor(.black)

                    Spacer()
                }
            }
            .navigationTitle(L10n.AddNewFeed.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func startScanningFeed() {
        print("Start scanning \(feedUrl)")
    }
}

struct AddFeedView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddFeedView()
        }
    }
}
