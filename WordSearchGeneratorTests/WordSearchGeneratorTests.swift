//
//  WordSearchGeneratorTests.swift
//  WordSearchGeneratorTests
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import XCTest
@testable import WordSearchGenerator

class WordSearchGeneratorTests: XCTestCase {
    
    func createTestWordlist(words: Int) -> Wordlist {
        let wordlist = Wordlist(title: UUID().uuidString)
        XCTAssertEqual(wordlist.words.count, 0)
        for _ in 0 ..< words {
            let word = Word(word: UUID().uuidString)
            wordlist.words.append(word)
        }
        return wordlist
    }
    
    func testWordlistWith0WordsDetailedWordCountIsCorrect() {
        // given
        let wordlist = createTestWordlist(words: 0)
        
        // when
        let detailedWordCount = wordlist.detailedWordCount
        
        // then
        XCTAssertEqual(detailedWordCount, "(No Words)")
    }
    
    func testWordlistWith1WordDetailedWordCountIsCorrect() {
        // given
        let wordlist = createTestWordlist(words: 1)
        
        // when
        let detailedWordCount = wordlist.detailedWordCount
        
        // then
        XCTAssertEqual(detailedWordCount, "1 Word")
    }
    
    func testWordlistWith2WordsDetailedWordCountIsCorrect() {
        // given
        let wordlist = createTestWordlist(words: 2)
        
        // when
        let detailedWordCount = wordlist.detailedWordCount
        
        // then
        XCTAssertEqual(detailedWordCount, "2 Words")
    }
    
    func testWordlistWith10WordsDetailedWordCountIsCorrect() {
        // given
        let wordlist = createTestWordlist(words: 10)
        
        // when
        let detailedWordCount = wordlist.detailedWordCount
        
        // then
        XCTAssertEqual(detailedWordCount, "10 Words")
    }
}
