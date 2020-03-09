//
//  Wordlist.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import Foundation

class Wordlist: Codable {
    
    var title: String
    var words = [String]()
    
    var wordCountDescription: String {
        let wordCount = words.count
        if wordCount > 1 {
            return "\(wordCount) Words"
        } else if wordCount > 0 {
            return "\(wordCount) Word"
        } else {
            return "(No Words)"
        }
    }
    
    // MARK: - Initialization
    init(title: String) {
        self.title = title
    }
    
    // MARK: - Methods
    func isOriginal(word: String) -> Bool {
        return !words.contains {
            $0.trimmingCharacters(in: .whitespaces).lowercased() == word.trimmingCharacters(in: .whitespaces).lowercased()
        }
    }
    
    func sortWords() {
        words.sort()
    }
}
