//
//  ModelData.swift
//  NewsHubRss
//
//  Created by Aliaksei Mastounikau on 17.04.23.
//

import Foundation

final class ModelData: ObservableObject {
    @Published var feeds: [Feed] = [
        Feed(id: 0, title: "ИТ в Беларуси | dev.by", link: "https://devby.io/rss"),
        Feed(id: 1, title: "Хабр", link: "https://habr.com/ru/rss/news/?fl=ru")
    ]
}
