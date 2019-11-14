//
//  ListDetailViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding wordlist: Wordlist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing wordlist: Wordlist)
}

class ListDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    var doneButtonItem: UIBarButtonItem!
    
    var wordlistToEdit: Wordlist?
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButtonItem
        
        if let wordlist = wordlistToEdit {
            title = "Edit Wordlist"
            titleTextField.text = wordlist.title
            doneButtonItem.isEnabled = true
        } else {
            title = "Add Wordlist"
            doneButtonItem.isEnabled = false
        }
        
        titleTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        titleTextField.resignFirstResponder()
    }
    
    // MARK: - Actions
    @objc func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let wordlist = wordlistToEdit {
            wordlist.title = titleTextField.text!
            delegate?.listDetailViewController(self, didFinishEditing: wordlist)
        } else {
            let wordlist = Wordlist(title: titleTextField.text!)
            delegate?.listDetailViewController(self, didFinishAdding: wordlist)
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
    }
    
}

extension ListDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        let trimmedNewText = newText.trimmingCharacters(in: .whitespaces)
        let characterSet = CharacterSet(charactersIn: trimmedNewText)
        
        var allowed = CharacterSet()
        allowed.formUnion(.letters)
        allowed.insert(charactersIn: " ")
        
        doneButtonItem.isEnabled = !trimmedNewText.isEmpty
        return !trimmedNewText.isEmpty && newText.count <= MaxCharacterCount.title && allowed.isSuperset(of: characterSet)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButtonItem.isEnabled = false
        return true
    }
}
