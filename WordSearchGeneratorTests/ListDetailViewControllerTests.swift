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
    
    func testTitleShouldBeEditWordlistWhenWordlistIsSet() {
        // given
        let wordlist = Wordlist(title: UUID().uuidString)
        sut.wordlistToEdit = wordlist
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(sut.title, "Edit Wordlist")
    }
    
    func testTitleShouldBeAddWordlistWhenWordlistIsNotSet() {
        // given
        sut.wordlistToEdit = nil
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(sut.title, "Add Wordlist")
    }
    
    func testDoneButtonItemIsEnabledWhenWordlistIsSet() {
        // given
        let wordlist = Wordlist(title: UUID().uuidString)
        sut.wordlistToEdit = wordlist
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertTrue(sut.doneButtonItem.isEnabled)
    }
    
    func testDoneButtonItemIsDisabledWhenWordlistIsNotSet() {
        // given
        sut.wordlistToEdit = nil
        
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertFalse(sut.doneButtonItem.isEnabled)
    }

}
