//
//  WordList.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import Foundation

class WordList: Codable {
    var listName = ""
    var words = [Word]()
    
    init(name: String) {
        listName = name
    }
    
    convenience init() {
        self.init(name: "Unknown")
    }
}
