//
//  WordDetailViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

protocol WordDetailViewControllerDelegate: class {
    func wordDetailViewControllerDidCancel(_ controller: WordDetailViewController)
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishAdding word: String)
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishEditing word: String)
}

class WordDetailViewController: TextEntryViewController {
    
    var wordToEdit: String?
    
    weak var delegate: WordDetailViewControllerDelegate?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
    }
    
    // MARK: - Configuration methods
    override func configureViewController() {
        super.configureViewController()
        
        textField.delegate = self
        textField.placeholder = "Word"
        
        if let word = wordToEdit {
            title = "Edit Word"
            textField.text = word
            doneButtonItem.isEnabled = true
        } else {
            title = "Add Word"
            doneButtonItem.isEnabled = false
        }
    }
    
    // MARK: - Actions
    override func cancel() {
        delegate?.wordDetailViewControllerDidCancel(self)
    }
    
    override func done() {
        guard let word = textField.text?.trimmingCharacters(in: .whitespaces), !word.isEmpty else {
            presentAlertOnMainThread(title: "Text must not be empty", message: nil, buttonTitle: "OK")
            return
        }
        
        if wordToEdit != nil {
            delegate?.wordDetailViewController(self, didFinishEditing: word)
        } else {
            delegate?.wordDetailViewController(self, didFinishAdding: word)
        }
    }
    
    override func textChanged(_ sender: UITextField) {
        let word = sender.text ?? ""
        doneButtonItem.isEnabled = !word.isEmpty
        sender.text = word.replacingOccurrences(of: ".", with: " ")
    }
}

extension WordDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        var allowed = CharacterSet()
        allowed.formUnion(.lowercaseLetters)
        allowed.formUnion(.uppercaseLetters)
        allowed.insert(charactersIn: " ")
        
        return newText.count <= MaxCharacterCount.word && newText.unicodeScalars.allSatisfy { allowed.contains($0) }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
