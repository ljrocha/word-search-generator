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

class ListDetailViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    var wordListToEdit: WordList?
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        if let wordList = wordListToEdit {
            title = "Edit Word List"
            nameTextField.text = wordList.listName
        } else {
            title = "Add Word List"
        }
        
        nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextField.becomeFirstResponder()
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

}

extension ListDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
