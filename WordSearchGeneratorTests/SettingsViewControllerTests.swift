//
//  SettingsViewControllerTests.swift
//  WordSearchGeneratorTests
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import XCTest
@testable import WordSearchGenerator

class SettingsViewControllerTests: XCTestCase {
    
    var sut: SettingsViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testSettingsTitleShouldBeSettings() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertEqual(sut.title, "Settings")
    }
    
    func testGridSizeSegmentedControlIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.gridSizeSegmentedControl)
    }
    
    func testDifficultySegmentedControlIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.difficultySegmentedControl)
    }
    
    func testWordsSegmentedControlIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.wordsSegmentedControl)
    }
    
    func testTitleSegmentedControlIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.titleSegmentedControl)
    }
    
}
