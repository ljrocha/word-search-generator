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
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
            showEmptyTitleErrorMessage()
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
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        let title = sender.text ?? ""
        doneButtonItem.isEnabled = !title.isEmpty
    }
    
    // MARK: - Methods
    func showEmptyTitleErrorMessage() {
        let ac = UIAlertController(title: "Title must not be empty", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
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
