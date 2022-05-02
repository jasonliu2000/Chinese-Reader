//
//  WordDefinitionViewController.swift
//  Chinese Reader
//
//  Created by Jason Liu on 5/1/22.
//

import UIKit

class WordDefinitionViewController: UIViewController {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var pinyinLabel: UILabel!
    @IBOutlet weak var definitionTextView: UITextView!
    
    var wordToDefine: DictionaryEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordLabel.text = wordToDefine.simplified
        pinyinLabel.text = wordToDefine.pinyinDiacritic
        
        var definitionList = ""
        for def in wordToDefine.definitions {
            definitionList += "\(def)\n"
        }
        
        definitionTextView.text = definitionList
        //definitionTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLayoutSubviews() {
        definitionTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let viewControllerYDimension = ["y": self.view.frame.size.height]
        NotificationCenter.default.post(name: Notification.Name("WordDefinionViewControllerWillAppear"), object: nil, userInfo: viewControllerYDimension)
        //print(UIScreen.main.bounds.height)
        //print(self.view.frame.size.height)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("WordDefinionViewControllerWillDisappear"), object: nil)
    }

}
