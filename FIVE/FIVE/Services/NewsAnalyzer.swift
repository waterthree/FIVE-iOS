//
//  NewsAnalyzer.swift
//  FIVE
//
//  Created by Jianmiao Cai on 2/24/25.
//

import NaturalLanguage

class NewsAnalyzer {
    static func combineSimilarEntries(_ entries: [NewsEntry]) -> [NewsEntry] {
        var combinedEntries: [NewsEntry] = []
        var processedEntries = Set<UUID>()
        
        for entry in entries {
            if processedEntries.contains(entry.id) { continue }
            
            let similarEntries = entries.filter { isSimilar($0.title, entry.title) }
            let combinedTitle = entry.title
            let combinedSummary = similarEntries.map { $0.summary }.joined(separator: "\n\n")
            let combinedSource = similarEntries.map { $0.source }.joined(separator: ", ")
            
            let combinedEntry = NewsEntry(title: combinedTitle, summary: combinedSummary, source: combinedSource)
            combinedEntries.append(combinedEntry)
            
            for similarEntry in similarEntries {
                processedEntries.insert(similarEntry.id)
            }
        }
        
        return combinedEntries
    }
    
    private static func isSimilar(_ text1: String, _ text2: String) -> Bool {
        let threshold = 0.6 // Adjust as needed
        let embedding = NLEmbedding.wordEmbedding(for: .english)
        return embedding?.distance(between: text1, and: text2) ?? 1.0 < threshold
    }
    
    static func rankEntries(_ entries: [NewsEntry]) -> [NewsEntry] {
        return entries.sorted { $0.summary.components(separatedBy: "\n\n").count > $1.summary.components(separatedBy: "\n\n").count }
    }
}
