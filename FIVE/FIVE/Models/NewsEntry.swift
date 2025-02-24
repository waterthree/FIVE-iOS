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
    let source: String
}
