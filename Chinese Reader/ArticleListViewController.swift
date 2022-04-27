//
//  ViewController.swift
//  Chinese Reader
//
//  Created by Jason Liu on 4/26/22.
//

import UIKit

class ArticleListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dictionaryEntries: [DictionaryEntry]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")
        tableView.delegate = self
        tableView.dataSource = self
        
        let path = Bundle.main.path(forResource: "cc-cedict", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            dictionaryEntries = try JSONDecoder().decode([DictionaryEntry].self, from: data)
            print("success")
            for dictionaryEntry in dictionaryEntries {
                if dictionaryEntry.simplified == "本次" {
                    print(dictionaryEntry.definitions)
                }
            }
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArticle" {
            let destination = segue.destination as! ArticleViewController
            destination.dictionaryEntries = dictionaryEntries
            // let indexPathForSelectedRow = tableView.indexPathForSelectedRow!
            // destination.creature = creatures.creatureArray[indexPathForSelectedRow.row]
        }
    }
    
}



extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        return cell
    }
    
}
