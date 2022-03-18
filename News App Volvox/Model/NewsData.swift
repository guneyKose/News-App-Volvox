//
//  NewsData.swift
//  News App Volvox
//
//  Created by Güney Köse on 17.03.2022.
//

import Foundation

struct NewsData: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Articles]?
}
struct Articles: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String?
}
