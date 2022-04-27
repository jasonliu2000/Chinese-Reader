//
//  ArticleViewController.swift
//  Chinese Reader
//
//  Created by Jason Liu on 4/27/22.
//

import UIKit
import NaturalLanguage

class ArticleViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var dictionaryEntries: [DictionaryEntry]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnTextView(_:)))
        textView.addGestureRecognizer(tap)
    }
    
    @objc func tapOnTextView(_ tapGesture: UITapGestureRecognizer){
        let point = tapGesture.location(in: textView)
        if let detectedWord = getTextAtPosition(point, type: .word) {
            var definition: [String] = []
            for dictionaryEntry in dictionaryEntries {
                if dictionaryEntry.simplified == "\(detectedWord)" {
                    definition = dictionaryEntry.definitions
                    break
                }
            }
            
            // if word is not in dictionary:
            if definition.isEmpty {
                let recognizer = NLLanguageRecognizer()
                recognizer.processString(detectedWord)
                if let language = recognizer.dominantLanguage {
                    if language != .simplifiedChinese {
                        print("word is not chinese")
                    } else {
                        if let detectedCharacter = getTextAtPosition(point, type: .character) {
                            for dictionaryEntry in dictionaryEntries {
                                if dictionaryEntry.simplified == "\(detectedCharacter)" {
                                    definition = dictionaryEntry.definitions
                                    break
                                }
                            }
                            
                            print(detectedCharacter, definition)
                        } else {
                            print("Error: couldn't get character at the position!")
                        }
                    }
                }
            } else {
                print(detectedWord, definition)
            }
            
        } else {
            print("Error: couldn't get word at the position!")
        }
    }
    
    func getTextAtPosition(_ point: CGPoint, type granularity: UITextGranularity) -> String? {
        if let textPosition = textView.closestPosition(to: point) {
            if let range = textView.tokenizer.rangeEnclosingPosition(textPosition, with: granularity, inDirection: .storage(.backward)) {
                return textView.text(in: range)
            } else {
                print("Error: couldn't get range")
            }
        } else {
            print("Error: couldn't get text position")
        }
        
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
