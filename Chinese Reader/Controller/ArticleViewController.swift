//
//  ArticleViewController.swift
//  Chinese Reader
//
//  Created by Jason Liu on 4/27/22.
//

import UIKit
import NaturalLanguage

class ArticleViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var article: Article!
    var wordDefinition: DictionaryEntry!
    var wordPressedBottomY: CGFloat = 0 // relative to the screen
    var wordPressedBottomYRelativeToTextView: CGFloat = 0
    var topOfWDVC: CGFloat = 0 // relative to the screen
    var scrollViewLocationOffset: CGPoint = CGPoint(x: 0, y: 0)
    var unHideWord = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(self.view.frame.size.height)
        titleLabel.text = article.title
        sourceLabel.text = article.source.name
        publishedDateLabel.text = article.publishedAt
        textView.text = article.content
        
        do {
            let data = try Data(contentsOf: URL(string: article.image)!)
            imageView.image = UIImage(data: data)
        } catch {
            print("Error getting image")
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnTextView(_:)))
        textView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(wordDefinitionViewControllerWillAppear(_:)), name: Notification.Name("WordDefinionViewControllerWillAppear"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(wordDefinitionViewControllerWillDisappear(_:)), name: Notification.Name("WordDefinionViewControllerWillDisappear"), object: nil)
    }
    
    @objc func wordDefinitionViewControllerWillAppear(_ notification: Notification) {
        guard let wordDefinitionViewControllerYDim = notification.userInfo as? [String: CGFloat] else {
            return
        }
        
        let yOfViewController = wordDefinitionViewControllerYDim["y"]!
        topOfWDVC = self.view.frame.height - yOfViewController
        
        print(wordPressedBottomY)
        print(topOfWDVC)
        
        if wordPressedBottomY > topOfWDVC { // if the word pressed would be hidden by the WordDefinitionViewController that pops up
            unHideWord = true
            scrollViewLocationOffset = scrollView.contentOffset
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 500, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.verticalScrollIndicatorInsets = contentInsets
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollViewLocationOffset.y + wordPressedBottomY - topOfWDVC + 10), animated: true)
        }
    }
    
    @objc func wordDefinitionViewControllerWillDisappear(_ notification: Notification) {
        if unHideWord {
            scrollView.setContentOffset(scrollViewLocationOffset, animated: true)
        }
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.verticalScrollIndicatorInsets = contentInsets
        unHideWord = false
    }
    
    @objc func tapOnTextView(_ tapGesture: UITapGestureRecognizer){
        
        let point = tapGesture.location(in: textView)
        
        if let detectedWord = getTextAtPosition(point, type: .word) {
            var wordInDictionary = false
            for dictionaryEntry in CEDictionary.dictionaryEntries { // check to see if detectedWord is in dictionary...
                if dictionaryEntry.simplified == "\(detectedWord)" { // if it is in dictionary...
                    wordInDictionary = true
                    wordDefinition = dictionaryEntry
                    popUpDefinition(wordDefinition)
                    break
                }
            }
            
            // if word is not in dictionary:
            if !wordInDictionary {
                //let recognizer = NLLanguageRecognizer()
                //recognizer.processString(detectedWord)
                if let language = NLLanguageRecognizer.dominantLanguage(for: detectedWord) {
                    if (language == .simplifiedChinese) || (language == .traditionalChinese) { // Apple might classify simplified characters as traditional...
                        if let detectedCharacter = getTextAtPosition(point, type: .character) {
                            for dictionaryEntry in CEDictionary.dictionaryEntries {
                                if dictionaryEntry.simplified == "\(detectedCharacter)" {
                                    wordDefinition = dictionaryEntry
                                    popUpDefinition(wordDefinition)
                                    break
                                }
                            }
                        } else {
                            print("Error: couldn't get character at the position!")
                        }
                    } else {
                        print("word is not chinese")
                    }
                } else {
                    print("Error: couldn't detect the language of detectedWord")
                }
                
            }
        } else {
            print("Error: couldn't get word at the position!")
        }
    }
    
    func getTextAtPosition(_ point: CGPoint, type granularity: UITextGranularity) -> String? {
        if let textPosition = textView.closestPosition(to: point) {
            if let range = textView.tokenizer.rangeEnclosingPosition(textPosition, with: granularity, inDirection: .storage(.backward)) {
                if let textRect = textView.selectionRects(for: range).last?.rect {
                    wordPressedBottomY = textView.convert(textRect, to: self.view).maxY
                    wordPressedBottomYRelativeToTextView = textRect.maxY
                } else {
                    print("Error: couldn't get bottom Y value of the pressed word")
                }
                
                return textView.text(in: range)
            } else {
                print("Error: couldn't get range")
            }
        } else {
            print("Error: couldn't get text position")
        }
        
        return nil
    }

    func popUpDefinition(_ definition: DictionaryEntry) {
        let yourVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "123") as! WordDefinitionViewController
        if let presentationController = yourVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
            //print((presentationController as! NSValue).cgRectValue)
        }
        
        yourVC.wordToDefine = definition
        self.present(yourVC, animated: true)
    }
    
}
