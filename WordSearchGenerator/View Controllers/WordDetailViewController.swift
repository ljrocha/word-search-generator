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
    
    // MARK: - Actions
    @objc func cancel() {
        delegate?.wordDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        let word = wordTextField.text!
        
        if wordToEdit != nil {
            delegate?.wordDetailViewController(self, didFinishEditing: word)
        } else {
            delegate?.wordDetailViewController(self, didFinishAdding: word)
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension WordDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneButtonItem.isEnabled = !newText.isEmpty
        return newText.count <= MaxCharacterCount.word
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButtonItem.isEnabled = false
        return true
    }
}
