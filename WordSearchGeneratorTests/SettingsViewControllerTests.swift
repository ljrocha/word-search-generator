//
//  SettingsViewControllerTests.swift
//  WordSearchGeneratorTests
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import XCTest
@testable import WordSearchGen

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
    
    func testTitleSwitchControlIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.titleSwitch)
    }
    
    func testGridLinesSwitchControlIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.gridLinesSwitch)
    }
    
    func testWordsSwitchControlIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.wordsSwitch)
    }
    
    func testDifficultySegmentedControlIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.difficultySegmentedControl)
    }
    
    func testGridSizeLabelIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.gridSizeLabel)
    }
    
    func testGridSizeStepperControlIsNotNil() {
        // when
        sut.loadViewIfNeeded()
        
        // then
        XCTAssertNotNil(sut.gridSizeStepper)
    }
}
