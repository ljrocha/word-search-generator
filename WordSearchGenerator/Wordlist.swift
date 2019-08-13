//
//  Wordlist.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import Foundation

class Wordlist: Codable {
    var title = ""
    var words = [Word]()
    
    init(title: String) {
        self.title = title
    }
}
