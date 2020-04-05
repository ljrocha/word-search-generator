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

class ListDetailViewController: TextEntryViewController {
    
    var wordlistToEdit: Wordlist?
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
    }
    
    // MARK: - Configuration methods
    override func configureViewController() {
        super.configureViewController()
        
        textField.delegate = self
        textField.placeholder = "Title"
        
        if let wordlist = wordlistToEdit {
            title = "Edit Wordlist"
            textField.text = wordlist.title
            doneButtonItem.isEnabled = true
        } else {
            title = "Add Wordlist"
            doneButtonItem.isEnabled = false
        }
    }
    
    // MARK: - Actions
    override func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    override func done() {
        guard let title = textField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
            presentAlertOnMainThread(title: "Invalid entry", message: "Text must not be empty.", buttonTitle: "OK")
            return
        }
        
        if let wordlist = wordlistToEdit {
            wordlist.title = title
            delegate?.listDetailViewController(self, didFinishEditing: wordlist)
        } else {
            let wordlist = Wordlist(title: title)
            delegate?.listDetailViewController(self, didFinishAdding: wordlist)
        }
    }
    
    override func textChanged(_ sender: UITextField) {
        let title = sender.text ?? ""
        doneButtonItem.isEnabled = !title.isEmpty
    }
    
}

extension ListDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        return newText.count <= MaxCharacterCount.title
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
