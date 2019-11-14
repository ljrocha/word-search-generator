//
//  WordlistViewControllerTests.swift
//  WordSearchGeneratorTests
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import XCTest
@testable import WordSearchGenerator

class WordlistViewControllerTests: XCTestCase {

    var sut: WordlistViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "WordlistViewController") as! WordlistViewController)
        sut.wordlist = Wordlist(title: UUID().uuidString)
    }

    override func tearDown() {
        sut = nil
    }
    
    func testTableViewIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.tableView)
    }
    
    func testWordSearchButtonIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.wordSearchButton)
    }
    
    func testWordSearchButtonIsEnabledWhenWordlistStartsNonEmpty() {
        // given
        let word = Word(word: UUID().uuidString)
        sut.wordlist.words.append(word)
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertTrue(sut.wordSearchButton.isEnabled)
    }
    
    func testWordSearchButtonIsDisabledWhenWordlistStartsEmpty() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertFalse(sut.wordSearchButton.isEnabled)
    }

}
