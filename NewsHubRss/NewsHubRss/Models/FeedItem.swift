import FeedKit
import Foundation

enum FeedItemData {
    case rssFeed(RSSFeedItem)
    case atomFeed(AtomFeedEntry)
    case jsonFeed(JSONFeedItem)
}

struct FeedItem: Identifiable {
    let id: Int
    let feedItemData: FeedItemData

    var title: String? {
        switch feedItemData {
        case .rssFeed(let item):
            return item.title
        case .atomFeed(let item):
            return item.title
        case .jsonFeed(let item):
            return item.title
        }
    }

    var link: String? {
        switch feedItemData {
        case .rssFeed(let item):
            return item.link
        case .atomFeed(let item):
            return item.links?.first?.attributes?.href
        case .jsonFeed(let item):
            return item.url
        }
    }

    var publishedDate: Date? {
        switch feedItemData {
        case .rssFeed(let item):
            return item.pubDate
        case .atomFeed(let item):
            return item.published
        case .jsonFeed(let item):
            return item.datePublished
        }
    }

    var author: String? {
        switch feedItemData {
        case .rssFeed(let item):
            return item.author ?? item.dublinCore?.dcCreator
        case .atomFeed(let item):
            return item.authors?.first?.name
        case .jsonFeed(let item):
            return item.author?.name
        }
    }

    var guid: String? {
        switch feedItemData {
        case .rssFeed(let item):
            return item.guid?.value
        case .atomFeed(let item):
            return item.id
        case .jsonFeed(let item):
            return item.url
        }
    }

    var enclosureLink: String? {
        switch feedItemData {
        case .rssFeed(let rSSFeedItem):
            return rSSFeedItem.enclosure?.attributes?.url
        case .atomFeed(let atomFeedEntry):
            return atomFeedEntry.media?.mediaThumbnails?.first?.attributes?.url
        case .jsonFeed(let jSONFeedItem):
            return jSONFeedItem.bannerImage
        }
    }
}
