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
            
            if similarEntries.count == 1 {
                // If no similar entries are found, create a new entry with combinedCount = 1
                let singleEntry = NewsEntry(
                    title: entry.title,
                    summary: entry.summary,
                    sources: entry.sources,
                    combinedCount: 1, // Explicitly set combinedCount to 1
                    date: entry.date
                )
                combinedEntries.append(singleEntry)
            } else {
                // Combine similar entries
                let combinedTitle = entry.title
                let combinedSummary = similarEntries.map { $0.summary }.joined(separator: "\n\n")
                let combinedSources = similarEntries.flatMap { $0.sources } // Combine all sources
                let combinedCount = similarEntries.count // Number of combined entries
                let combinedDate = similarEntries.compactMap { $0.date }.max() // Latest date among combined entries
                
                let combinedEntry = NewsEntry(
                    title: combinedTitle,
                    summary: combinedSummary,
                    sources: combinedSources,
                    combinedCount: combinedCount,
                    date: combinedDate
                )
                combinedEntries.append(combinedEntry)
            }
            
            for similarEntry in similarEntries {
                processedEntries.insert(similarEntry.id)
            }
        }
        
        return combinedEntries
    }
    
    private static func isSimilar(_ text1: String, _ text2: String) -> Bool {
        // If the texts are identical, they are similar
        if text1 == text2 {
            return true
        }
        
        let threshold = 0.8 // Adjust as needed
        let embedding = NLEmbedding.wordEmbedding(for: .english)
        return embedding?.distance(between: text1, and: text2) ?? 1.0 < threshold
    }
    
    static func rankEntries(_ entries: [NewsEntry]) -> [NewsEntry] {
        return entries.sorted {
            if $0.combinedCount != $1.combinedCount {
                // Sort by combinedCount (descending)
                return $0.combinedCount > $1.combinedCount
            } else {
                // If combinedCount is the same, sort by date (newest first)
                guard let date1 = $0.date, let date2 = $1.date else { return false }
                return date1 > date2
            }
        }
    }
}
