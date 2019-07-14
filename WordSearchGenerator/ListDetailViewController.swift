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
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding wordList: WordList)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing wordList: WordList)
}

class ListDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    var doneButtonItem: UIBarButtonItem!
    
    var wordListToEdit: WordList?
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButtonItem
        
        if let wordList = wordListToEdit {
            title = "Edit Word List"
            nameTextField.text = wordList.listName
            doneButtonItem.isEnabled = true
        } else {
            title = "Add Word List"
            doneButtonItem.isEnabled = false
        }
        
        nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @objc func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @objc func done() {
        if let wordList = wordListToEdit {
            wordList.listName = nameTextField.text!
            delegate?.listDetailViewController(self, didFinishEditing: wordList)
        } else {
            let wordList = WordList(name: nameTextField.text!)
            delegate?.listDetailViewController(self, didFinishAdding: wordList)
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
    }
    
}

extension ListDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneButtonItem.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButtonItem.isEnabled = false
        return true
    }
}
