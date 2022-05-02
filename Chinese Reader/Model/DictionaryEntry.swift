//
//  DictionaryEntry.swift
//  Chinese Reader
//
//  Created by Jason Liu on 4/26/22.
//

import Foundation

struct DictionaryEntry: Codable {
    var traditional: String
    var simplified: String
    // var pinyinNumeric: String
    var pinyinDiacritic: String
    var definitions: [String]
}
