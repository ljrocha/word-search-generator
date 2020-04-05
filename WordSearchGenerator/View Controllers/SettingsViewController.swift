//
//  SettingsViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 7/18/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit
import SafariServices

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var titleSwitch: UISwitch!
    @IBOutlet weak var gridLinesSwitch: UISwitch!
    @IBOutlet weak var wordsSwitch: UISwitch!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var gridSizeLabel: UILabel!
    @IBOutlet weak var gridSizeStepper: UIStepper!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
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
        
        // Grid lines
        gridLinesSwitch.isOn = defaults.bool(forKey: Key.UserDefaults.gridLinesIncluded)
        
        // Words
        wordsSwitch.isOn = defaults.bool(forKey: Key.UserDefaults.wordsIncluded)
        
        // Difficulty
        difficultySegmentedControl.selectedSegmentIndex = defaults.integer(forKey: Key.UserDefaults.difficulty)
        
        // Grid size
        let size = defaults.integer(forKey: Key.UserDefaults.gridSize)
        gridSizeLabel.text = "\(size) x \(size)"
        gridSizeStepper.value = Double(size)
        
        // Privacy policy
        privacyPolicyButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    // MARK: - Methods
    @IBAction func switchChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        
        switch sender.tag {
        case 1000:
            // Title
            defaults.set(sender.isOn, forKey: Key.UserDefaults.titleIncluded)
        case 1001:
            // Grid lines
            defaults.set(gridLinesSwitch.isOn, forKey: Key.UserDefaults.gridLinesIncluded)
        case 1002:
            // Words
            defaults.set(sender.isOn, forKey: Key.UserDefaults.wordsIncluded)
        default:
            fatalError("Unrecognized switch control tag")
        }
        
        settingsUpdated()
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        //Difficulty
        if let difficulty = Difficulty(rawValue: sender.selectedSegmentIndex) {
            UserDefaults.standard.set(difficulty.rawValue, forKey: Key.UserDefaults.difficulty)
        }
        
        settingsUpdated()
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        // Grid size
        let value = Int(sender.value)
        gridSizeLabel.text = "\(value) x \(value)"
        
        UserDefaults.standard.set(value, forKey: Key.UserDefaults.gridSize)
        
        settingsUpdated()
    }
    
    func settingsUpdated() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(Key.Notification.settingsUpdated), object: nil)
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "https://github.com/ljrocha/word-search-generator/blob/privacy-policy/PRIVACY.md") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
    }
    
}
