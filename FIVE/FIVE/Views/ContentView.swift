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
                NavigationLink(destination: SourcesView(entry: entry)) {
                    HStack {
                        // Entry details (title and summary)
                        VStack(alignment: .leading) {
                            Text(entry.title)
                                .font(.headline)
                                .lineLimit(3)
                            
                            Text(entry.summary)
                                .font(.footnote)
                                .lineLimit(2)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer() // Push the number to the right
                        
                        // Display the combinedCount on the right side
                        Text("\(entry.combinedCount)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
            }
            .navigationTitle("FIVE")
            .toolbar {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                }
            }
            .refreshable {
                fetcher.fetchFeeds()
            }
            .onReceive(fetcher.$entries) { entries in
                let combinedEntries = NewsAnalyzer.combineSimilarEntries(entries)
                topEntries = NewsAnalyzer.rankEntries(combinedEntries)
            }
        }
    }
}
