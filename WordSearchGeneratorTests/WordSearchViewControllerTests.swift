//
//  WordSearchViewControllerTests.swift
//  WordSearchGeneratorTests
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import XCTest
@testable import WordSearchGenerator

class WordSearchViewControllerTests: XCTestCase {
    
    var sut: WordSearchViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "WordSearchViewController") as! WordSearchViewController)
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
