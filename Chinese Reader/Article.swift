//
//  Article.swift
//  Chinese Reader
//
//  Created by Jason Liu on 4/27/22.
//

import Foundation

struct Article: Codable {
    var title: String
    var description: String
    var content: String
    var image: String
    var publishedAt: String
    var source: Source
}

struct Source: Codable {
    var name: String
}
