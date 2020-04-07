//
//  ListDetailViewControllerTests.swift
//  WordSearchGeneratorTests
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import XCTest
@testable import WordSearchGen

class ListDetailViewControllerTests: XCTestCase {

    var sut: ListDetailViewController!
    
    override func setUp() {
        sut = ListDetailViewController()
    }

    override func tearDown() {
        sut = nil
    }
    
    func testNameTextFieldIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.textField)
    }
    
    func testDoneButtonItemIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.doneButtonItem)
    }
    
    func testTitleShouldBeEditWordListWhenWordListIsSet() {
        // given
        let wordList = WordList(title: UUID().uuidString)
        sut.wordListToEdit = wordList
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(sut.title, "Edit Word List")
    }
    
    func testTitleShouldBeAddWordListWhenWordListIsNotSet() {
        // given
        sut.wordListToEdit = nil
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(sut.title, "Add Word List")
    }
    
    func testDoneButtonItemIsEnabledWhenWordListIsSet() {
        // given
        let wordList = WordList(title: UUID().uuidString)
        sut.wordListToEdit = wordList
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertTrue(sut.doneButtonItem.isEnabled)
    }
    
    func testDoneButtonItemIsDisabledWhenWordListIsNotSet() {
        // given
        sut.wordListToEdit = nil
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertFalse(sut.doneButtonItem.isEnabled)
    }

}
