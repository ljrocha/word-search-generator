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
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishAdding word: Word)
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishEditing word: Word)
}

class WordDetailViewController: UIViewController {

    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var clueTextField: UITextField!
    
    var doneButtonItem: UIBarButtonItem!
    
    var wordToEdit: Word?
    
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
            wordTextField.text = word.text
            clueTextField.text = word.clue
            
            doneButtonItem.isEnabled = true
        } else {
            title = "Add Word"
            
            doneButtonItem.isEnabled = false
        }
        
        wordTextField.delegate = self
        clueTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        wordTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @objc func cancel() {
        delegate?.wordDetailViewControllerDidCancel(self)
    }
    
    @objc func done() {
        if let word = wordToEdit {
            word.text = wordTextField.text!
            word.clue = clueTextField.text!
            delegate?.wordDetailViewController(self, didFinishEditing: word)
        } else {
            let word = Word(word: wordTextField.text!, clue: clueTextField.text!)
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
        
        if textField.tag == 1000 {
            doneButtonItem.isEnabled = !newText.isEmpty
            return newText.count <= MaxCharacterCount.word
        } else if textField.tag == 1001 {
            return newText.count <= MaxCharacterCount.clue
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField.tag == 1000 {
            doneButtonItem.isEnabled = false
        }
        return true
    }
}
