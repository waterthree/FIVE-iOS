//
//  SourceView.swift
//  FIVE
//
//  Created by Jianmiao Cai on 2/24/25.
//

import SwiftUI

struct SourcesView: View {
    let entry: NewsEntry
    
    var body: some View {
        List(entry.sources, id: \.self) { source in
            if let url = URL(string: source) {
                Link(destination: url) {
                    VStack(alignment: .leading) {
                        Text(entry.title).font(.headline).lineLimit(3)
                        Text(entry.summary).font(.footnote).lineLimit(2)
                        Divider()
                        Text("Source: \(source)").font(.caption).italic()
                    }
                }
            } else {
                VStack(alignment: .leading) {
                    Text(entry.title).font(.headline).lineLimit(3)
                    Text(entry.summary).font(.footnote).lineLimit(2)
                    Text("Source: \(source)").font(.caption)
                }
            }
        }
        .navigationTitle("Sources")
    }
}
