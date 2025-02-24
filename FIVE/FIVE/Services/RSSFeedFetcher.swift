//
//  RSSFeedFetcher.swift
//  FIVE
//
//  Created by Jianmiao Cai on 2/24/25.
//

import Foundation
import FeedKit
import Combine

class RSSFeedFetcher: ObservableObject {
    @Published var entries: [NewsEntry] = [] // @Published makes it observable
    
    func fetchFeeds(from urls: [String], limit: Int) {
        for url in urls {
            guard let feedURL = URL(string: url) else {
                print("Invalid URL: \(url)")
                continue
            }
            let parser = FeedParser(URL: feedURL)
            
            parser.parseAsync { result in
                switch result {
                case .success(let feed):
                    if let items = feed.rssFeed?.items {
                        print("Fetched \(items.count) items from \(url)")
                        let newEntries = items.prefix(limit).map { item in
                            NewsEntry(title: item.title ?? "No Title", summary: item.description ?? "No Summary", source: url)
                        }
                        DispatchQueue.main.async {
                            self.entries.append(contentsOf: newEntries)
                        }
                    } else {
                        print("No items found in feed from \(url)")
                    }
                case .failure(let error):
                    print("Error fetching feed from \(url): \(error.localizedDescription)")
                }
            }
        }
    }
}
