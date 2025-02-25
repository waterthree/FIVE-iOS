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
    @Published var entries: [NewsEntry] = []
    
    init() {
        fetchFeeds()
    }
    
    func fetchFeeds() {
        let rssURLs = UserDefaults.standard.string(forKey: "rssURLs")?.components(separatedBy: ",") ?? []
        let fetchLimit = UserDefaults.standard.integer(forKey: "fetchLimit")
        
        // Clear existing entries before fetching new ones
        DispatchQueue.main.async {
            self.entries.removeAll()
        }
        
        for url in rssURLs {
            guard let feedURL = URL(string: url) else { continue }
            let parser = FeedParser(URL: feedURL)
            
            parser.parseAsync { result in
                switch result {
                case .success(let feed):
                    if let items = feed.rssFeed?.items {
                        let newEntries = items.prefix(fetchLimit).map { item in
                            NewsEntry(
                                title: item.title ?? "",    // "" for No Title
                                summary: item.description ?? "",    // "" for No Summary
                                sources: [item.guid?.value ?? url], // Single source for each item
                                combinedCount: 1, // Each item is initially a single entry
                                date: item.pubDate // Publication date
                            )
                        }
                        DispatchQueue.main.async {
                            self.entries.append(contentsOf: newEntries)
                        }
                    }
                case .failure(let error):
                    print("Error fetching feed from \(url): \(error.localizedDescription)")
                }
            }
        }
    }
}
