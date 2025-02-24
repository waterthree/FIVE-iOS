//
//  ContentView.swift
//  FIVE
//
//  Created by Jianmiao Cai on 2/24/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var fetcher = RSSFeedFetcher()
    @State private var topEntries: [NewsEntry] = []
    
    var body: some View {
        NavigationView {
            List(topEntries.prefix(5), id: \.id) { entry in
                VStack(alignment: .leading) {
                    Text(entry.title).font(.headline)
                    Text(entry.summary).font(.subheadline)
                    Text("Source: \(entry.source)").font(.caption)
                }
            }
            .navigationTitle("FIVE")
            .toolbar {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                }
            }
            .onAppear {
                let rssURLs = UserDefaults.standard.string(forKey: "rssURLs")?.components(separatedBy: ",") ?? []
                let fetchLimit = UserDefaults.standard.integer(forKey: "fetchLimit")
//                print("Fetching feeds from: \(rssURLs)")
                fetcher.fetchFeeds(from: rssURLs, limit: fetchLimit)
            }
            .onReceive(fetcher.$entries) { entries in
//                print("Fetched \(entries.count) entries")
                let combinedEntries = NewsAnalyzer.combineSimilarEntries(entries)
//                print("Combined entries: \(combinedEntries.count)")
                topEntries = NewsAnalyzer.rankEntries(combinedEntries)
//                print("Top entries: \(topEntries.count)")
            }
        }
    }
}
