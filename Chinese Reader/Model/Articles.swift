//
//  NetworkManager.swift
//  Chinese Reader
//
//  Created by Jason Liu on 4/27/22.
//

import Foundation
import UIKit

class Articles {
    
    private struct Returned: Codable {
        var articles: [Article]
    }
    
    var articleArray: [Article] = []
    
    func fetchData(completed: @escaping () -> ()) {
        if let url = URL(string: "https://gnews.io/api/v4/top-headlines?country=cn&token=\(APIKeys.gNewsKey)") {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    do {
                        let results = try JSONDecoder().decode(Returned.self, from: data!)
                        self.articleArray = results.articles
                    } catch {
                        print("Error: JSON error")
                    }
                }
                completed()
            }
            
            task.resume()
        } else {
            print("Error: URL string not found")
            completed()
            return
        }
    }
    
    // only for testing purposes:
    func parseJSONDict() {
        let path = Bundle.main.path(forResource: "articles", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let results = try JSONDecoder().decode(Returned.self, from: data)
            self.articleArray = results.articles
        } catch {
            print("Did not retrieve articles!")
            print(error)
        }
    }
    
}
