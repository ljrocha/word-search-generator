//
//  Word.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import Foundation

class Word: Codable {
    var text: String
    var clue: String
    
    init(word: String, clue: String) {
        text = word
        self.clue = clue
    }
}
