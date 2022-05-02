//
//  CEDictionary.swift
//  Chinese Reader
//
//  Created by Jason Liu on 4/27/22.
//

import Foundation

class CEDictionary {
    static var dictionaryEntries: [DictionaryEntry] = []
    
    static func parseJSONDict() {
        let path = Bundle.main.path(forResource: "cc-cedict", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            dictionaryEntries = try JSONDecoder().decode([DictionaryEntry].self, from: data)
//            print("success")
//            for dictionaryEntry in dictionaryEntries {
//                if dictionaryEntry.simplified == "本次" {
//                    print(dictionaryEntry.definitions)
//                }
//            }
        } catch {
            print(error)
        }
    }
}
