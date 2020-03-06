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

class WordDetailViewController: UIViewController {

    @IBOutlet weak var wordTextField: UITextField!
    var doneButtonItem: UIBarButtonItem!
    
    var wordToEdit: String?
    
    weak var delegate: WordDetailViewControllerDelegate?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        wordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        wordTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        wordTextField.resignFirstResponder()
    }
    
    // MARK: - Configuration methods
    func configureViewController() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButtonItem
        
        if let word = wordToEdit {
            title = "Edit Word"
            wordTextField.text = word
            doneButtonItem.isEnabled = true
        } else {
            title = "Add Word"
            doneButtonItem.isEnabled = false
        }
    }
    
    // MARK: - Actions
    @objc func cancel() {
        delegate?.wordDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        guard let word = wordTextField.text?.trimmingCharacters(in: .whitespaces), !word.isEmpty else {
            showEmptyWordErrorMessage()
            return
        }
        
        if wordToEdit != nil {
            delegate?.wordDetailViewController(self, didFinishEditing: word)
        } else {
            delegate?.wordDetailViewController(self, didFinishAdding: word)
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        let word = sender.text ?? ""
        doneButtonItem.isEnabled = !word.isEmpty
        sender.text = word.replacingOccurrences(of: ".", with: " ")
    }
    
    // MARK: - Methods
    func showEmptyWordErrorMessage() {
        let ac = UIAlertController(title: "Word must not be empty", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
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
