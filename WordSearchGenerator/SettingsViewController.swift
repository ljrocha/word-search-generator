//
//  SettingsViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 7/18/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var gridSizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var wordsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSegmentedControls()
    }
    
    func setupSegmentedControls() {
        let defaults = UserDefaults.standard
        
        // Title
        if defaults.bool(forKey: Key.UserDefaults.titleIncluded) == true {
            titleSegmentedControl.selectedSegmentIndex = 0
        } else {
            titleSegmentedControl.selectedSegmentIndex = 1
        }
        
        // Words
        if defaults.bool(forKey: Key.UserDefaults.wordsIncluded) == true {
            wordsSegmentedControl.selectedSegmentIndex = 0
        } else {
            wordsSegmentedControl.selectedSegmentIndex = 1
        }
        
        // Grid size
        let size = defaults.integer(forKey: Key.UserDefaults.gridSize)
        if size == 10 {
            gridSizeSegmentedControl.selectedSegmentIndex = 0
        } else if size == 12 {
            gridSizeSegmentedControl.selectedSegmentIndex = 1
        } else {
            gridSizeSegmentedControl.selectedSegmentIndex = 2
        }
        
        // Difficulty
        difficultySegmentedControl.selectedSegmentIndex = defaults.integer(forKey: Key.UserDefaults.difficulty)
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let defaults = UserDefaults.standard
        
        switch sender.tag {
        case 1000:
            // Title
            if sender.selectedSegmentIndex == 0 {
                defaults.set(true, forKey: Key.UserDefaults.titleIncluded)
            } else {
                defaults.set(false, forKey: Key.UserDefaults.titleIncluded)
            }
        case 1001:
            // Words
            if sender.selectedSegmentIndex == 0 {
                defaults.set(true, forKey: Key.UserDefaults.wordsIncluded)
            } else {
                defaults.set(false, forKey: Key.UserDefaults.wordsIncluded)
            }
        case 1002:
            // Grid Size
            if sender.selectedSegmentIndex == 0 {
                defaults.set(GridSize.small.rawValue, forKey: Key.UserDefaults.gridSize)
            } else if sender.selectedSegmentIndex == 1 {
                defaults.set(GridSize.medium.rawValue, forKey: Key.UserDefaults.gridSize)
            } else {
                defaults.set(GridSize.large.rawValue, forKey: Key.UserDefaults.gridSize)
            }
        case 1003:
            // Difficulty
            if sender.selectedSegmentIndex == 0 {
                defaults.set(Difficulty.easy.rawValue, forKey: Key.UserDefaults.difficulty)
            } else if sender.selectedSegmentIndex == 1 {
                defaults.set(Difficulty.medium.rawValue, forKey: Key.UserDefaults.difficulty)
            } else {
                defaults.set(Difficulty.hard.rawValue, forKey: Key.UserDefaults.difficulty)
            }
        default:
            fatalError("Unrecognized segmented control tag")
        }
    }
    
}
