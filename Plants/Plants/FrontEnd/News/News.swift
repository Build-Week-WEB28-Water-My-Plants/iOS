//
//  News.swift
//  Plants
//
//  Created by Alexander Supe on 03.02.20.
//

import Foundation

struct News: Codable {
    var title: String
    var pubDate: String
    var link: String?
    var author: String?
    var enclosure: Enclosure?
    var image: Data?
}

struct Enclosure: Codable {
    var link: String?
}

struct NewsArticles: Codable {
    var items: [News]
}
