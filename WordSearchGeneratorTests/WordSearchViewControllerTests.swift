//
//  WordSearchViewControllerTests.swift
//  WordSearchGeneratorTests
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import XCTest
@testable import WordSearchGen

class WordSearchViewControllerTests: XCTestCase {
    
    var sut: WordSearchViewController!

    override func setUp() {
        sut = WordSearchViewController()
    }

    override func tearDown() {
        sut = nil
    }
    
    func testWordSearchTitleShouldBeWordSearchPuzzle() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(sut.title, "Word Search Puzzle")
        
    }
    
    func testPDFViewIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.pdfView)
    }

}
