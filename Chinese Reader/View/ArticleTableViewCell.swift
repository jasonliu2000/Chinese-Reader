//
//  ArticleTableViewCell.swift
//  Chinese Reader
//
//  Created by Jason Liu on 4/27/22.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    var titleLabelHeight: CGFloat = 0
    var sourceLabelHeight: CGFloat = 0
    
    var article: Article! {
        didSet {
            titleLabel.text = article.title
            sourceLabel.text = article.source.name
            titleLabelHeight = titleLabel.bounds.size.height
            sourceLabelHeight = sourceLabel.bounds.size.height
        }
    }
}
