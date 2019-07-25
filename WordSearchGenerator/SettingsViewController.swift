//
//  SettingsViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 7/18/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var gridSize: UISegmentedControl!
    @IBOutlet weak var difficulty: UISegmentedControl!
    @IBOutlet weak var clues: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSegmentedControls()
    }
    
    func setupSegmentedControls() {
        let defaults = UserDefaults.standard
        
        let size = defaults.integer(forKey: Key.UserDefaults.gridSize)
        if size == 8 {
            gridSize.selectedSegmentIndex = 0
        } else if size == 10 {
            gridSize.selectedSegmentIndex = 1
        } else {
            gridSize.selectedSegmentIndex = 2
        }
        
        difficulty.selectedSegmentIndex = defaults.integer(forKey: Key.UserDefaults.difficulty)
        
        if defaults.bool(forKey: Key.UserDefaults.cluesProvided) == false {
            clues.selectedSegmentIndex = 0
        } else {
            clues.selectedSegmentIndex = 1
        }
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let defaults = UserDefaults.standard
        
        switch sender.tag {
        case 0:
            // Grid Size
            if sender.selectedSegmentIndex == 0 {
                defaults.set(GridSize.small.rawValue, forKey: Key.UserDefaults.gridSize)
            } else if sender.selectedSegmentIndex == 1 {
                defaults.set(GridSize.medium.rawValue, forKey: Key.UserDefaults.gridSize)
            } else {
                defaults.set(GridSize.large.rawValue, forKey: Key.UserDefaults.gridSize)
            }
            break
        case 1:
            // Difficulty
            if sender.selectedSegmentIndex == 0 {
                defaults.set(Difficulty.easy.rawValue, forKey: Key.UserDefaults.difficulty)
            } else if sender.selectedSegmentIndex == 1 {
                defaults.set(Difficulty.medium.rawValue, forKey: Key.UserDefaults.difficulty)
            } else {
                defaults.set(Difficulty.hard.rawValue, forKey: Key.UserDefaults.difficulty)
            }
        case 2:
            // Provide Clues
            if sender.selectedSegmentIndex == 0 {
                defaults.set(false, forKey: Key.UserDefaults.cluesProvided)
            } else {
                defaults.set(true, forKey: Key.UserDefaults.cluesProvided)
            }
        default:
            fatalError("Unrecognized segmented control tag")
        }
    }
    
}
