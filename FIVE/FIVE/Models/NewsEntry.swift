//
//  NewsEntry.swift
//  FIVE
//
//  Created by Jianmiao Cai on 2/24/25.
//

import Foundation

struct NewsEntry: Identifiable {
    let id = UUID()
    let title: String
    let summary: String
    let sources: [String] // Store all sources for this entry
    let combinedCount: Int // Number of news items combined
    let date: Date? // Publication date (optional)
}
