//
//  ViewController.swift
//  Chinese Reader
//
//  Created by Jason Liu on 4/26/22.
//

import UIKit

class ArticleListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var articles = Articles()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        CEDictionary.parseJSONDict()
        
        articles.parseJSONDict()
//        articles.fetchData {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArticle" {
            let destination = segue.destination as! ArticleViewController
            let indexPathForSelectedRow = tableView.indexPathForSelectedRow!
            destination.article = articles.articleArray[indexPathForSelectedRow.row]
        }
    }
    
}



extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.articleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleTableViewCell
        cell.article = articles.articleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 100
        return height
    }
}
