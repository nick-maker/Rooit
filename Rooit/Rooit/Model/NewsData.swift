//
//  News.swift
//  Rooit
//
//  Created by Nick Liu on 2023/9/4.
//

import Foundation

// MARK: - News
struct NewsData: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author, title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt, content: String?
}

// MARK: - Source
struct Source: Codable {
    let id, name: String?
}
