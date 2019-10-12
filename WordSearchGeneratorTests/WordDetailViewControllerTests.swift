//
//  WordDetailViewControllerTests.swift
//  WordSearchGeneratorTests
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import XCTest
@testable import WordSearchGenerator

class WordDetailViewControllerTests: XCTestCase {
    
    var sut: WordDetailViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "WordDetailViewController") as! WordDetailViewController)
    }

    override func tearDown() {
        sut = nil
    }
    
    func testTitleShouldBeEditWordWhenWordIsSet() {
        // when
        sut.wordToEdit = Word(word: UUID().uuidString)
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(sut.title, "Edit Word")
    }
    
    func testTitleShouldBeAddWordWhenWordIsNotSet() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(sut.title, "Add Word")
    }
    
    func testDoneButtonItemIsDisabledWhenWordIsNotSet() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertFalse(sut.doneButtonItem.isEnabled)
    }
    
    func testDoneButtonItemIsEnabledWhenWordIsSet() {
        // when
        sut.wordToEdit = Word(word: UUID().uuidString)
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertTrue(sut.doneButtonItem.isEnabled)
    }
    
    func testWordTextFieldIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.wordTextField)
    }
    
    func testDoneButtonItemIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.doneButtonItem)
    }

}
