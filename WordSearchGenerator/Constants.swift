//
//  Constants.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 7/18/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import Foundation

struct Key {
    struct UserDefaults {
        static let gridSize = "GridSize"
        static let difficulty = "Difficulty"
        static let wordsIncluded = "WordsIncluded"
        static let titleIncluded = "TitleIncluded"
        static let gridLinesIncluded = "GridLinesIncluded"
    }
    
    struct Notification {
        static let settingsUpdated = "SettingsUpdated"
    }
}

struct MaxCharacterCount {
    static let title = 30
    static let word = 20
    static let clue = 75
}
