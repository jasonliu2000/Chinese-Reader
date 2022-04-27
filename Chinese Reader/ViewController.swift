//
//  ViewController.swift
//  Chinese Reader
//
//  Created by Jason Liu on 4/26/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "cc-cedict", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let dictionaryEntries = try JSONDecoder().decode([DictionaryEntry].self, from: data)
        } catch {
            print(error)
        }
    }


}

