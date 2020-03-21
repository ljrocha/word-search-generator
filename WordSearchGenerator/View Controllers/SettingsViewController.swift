//
//  SettingsViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 7/18/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var titleSwitch: UISwitch!
    @IBOutlet weak var wordsSwitch: UISwitch!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var gridSizeLabel: UILabel!
    @IBOutlet weak var gridSizeStepper: UIStepper!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        setUpControls()
    }
    
    // MARK: - Configuration methods
    func configureViewController() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func setUpControls() {
        let defaults = UserDefaults.standard
        
        // Title
        titleSwitch.isOn = defaults.bool(forKey: Key.UserDefaults.titleIncluded)
        
        // Words
        wordsSwitch.isOn = defaults.bool(forKey: Key.UserDefaults.wordsIncluded)
        
        // Difficulty
        difficultySegmentedControl.selectedSegmentIndex = defaults.integer(forKey: Key.UserDefaults.difficulty)
        
        // Grid size
        let size = defaults.integer(forKey: Key.UserDefaults.gridSize)
        gridSizeLabel.text = "\(size) x \(size)"
        gridSizeStepper.value = Double(size)
    }
    
    // MARK: - Methods
    @IBAction func switchChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        
        switch sender.tag {
        case 1000:
            // Title
            defaults.set(sender.isOn, forKey: Key.UserDefaults.titleIncluded)
        case 1001:
            // Words
            defaults.set(sender.isOn, forKey: Key.UserDefaults.wordsIncluded)
        default:
            fatalError("Unrecognized switch control tag")
        }
        
        settingsUpdated()
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let defaults = UserDefaults.standard
        
        switch sender.tag {
        case 1002:
            //Difficulty
            if let difficulty = Difficulty(rawValue: sender.selectedSegmentIndex) {
                defaults.set(difficulty.rawValue, forKey: Key.UserDefaults.difficulty)
            }
        default:
            fatalError("Unrecognized segmented control tag")
        }
        
        settingsUpdated()
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        gridSizeLabel.text = "\(value) x \(value)"
        
        UserDefaults.standard.set(value, forKey: Key.UserDefaults.gridSize)
        
        settingsUpdated()
    }
    
    func settingsUpdated() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(Key.Notification.settingsUpdated), object: nil)
    }
    
}
