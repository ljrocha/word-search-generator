//
//  WordListViewControllerTests.swift
//  WordSearchGeneratorTests
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import XCTest
@testable import WordSearchGen

class WordListViewControllerTests: XCTestCase {

    var sut: WordListViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "WordListViewController") as! WordListViewController)
        sut.wordList = WordList(title: UUID().uuidString)
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
    
    func testWordSearchButtonIsEnabledWhenWordListStartsNonEmpty() {
        // given
        let word = UUID().uuidString
        sut.wordList.words.append(word)
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertTrue(sut.wordSearchButton.isEnabled)
    }
    
    func testWordSearchButtonIsDisabledWhenWordListStartsEmpty() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertFalse(sut.wordSearchButton.isEnabled)
    }

}
