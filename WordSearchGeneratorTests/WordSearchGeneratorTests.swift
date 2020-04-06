//
//  WordSearchGeneratorTests.swift
//  WordSearchGeneratorTests
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import XCTest
@testable import WordSearchGen

class WordSearchGeneratorTests: XCTestCase {
    
    func createTestWordList(words: Int) -> WordList {
        let wordList = WordList(title: UUID().uuidString)
        XCTAssertEqual(wordList.words.count, 0)
        for _ in 0 ..< words {
            let word = UUID().uuidString
            wordList.words.append(word)
        }
        return wordList
    }
    
    func testWordListWith0WordsDetailedWordCountIsCorrect() {
        // given
        let wordList = createTestWordList(words: 0)
        
        // when
        let detailedWordCount = wordList.wordCountDescription
        
        // then
        XCTAssertEqual(detailedWordCount, "(No Words)")
    }
    
    func testWordListWith1WordDetailedWordCountIsCorrect() {
        // given
        let wordList = createTestWordList(words: 1)
        
        // when
        let detailedWordCount = wordList.wordCountDescription
        
        // then
        XCTAssertEqual(detailedWordCount, "1 Word")
    }
    
    func testWordListWith2WordsDetailedWordCountIsCorrect() {
        // given
        let wordList = createTestWordList(words: 2)
        
        // when
        let detailedWordCount = wordList.wordCountDescription
        
        // then
        XCTAssertEqual(detailedWordCount, "2 Words")
    }
    
    func testWordListWith10WordsDetailedWordCountIsCorrect() {
        // given
        let wordList = createTestWordList(words: 10)
        
        // when
        let detailedWordCount = wordList.wordCountDescription
        
        // then
        XCTAssertEqual(detailedWordCount, "10 Words")
    }
}
