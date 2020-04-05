//
//  AllListsViewControllerTests.swift
//  WordSearchGeneratorTests
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import XCTest
@testable import WordSearchGen

class AllListsViewControllerTests: XCTestCase {

    var sut: AllListsViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "AllListsViewController") as! AllListsViewController)
    }

    override func tearDown() {
        sut = nil
    }
    
    func testTitleShouldBeWordlists() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(sut.title, "Wordlists")
    }

}
