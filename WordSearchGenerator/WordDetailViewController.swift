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

class WordDetailViewController: UITableViewController {

    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var clueTextField: UITextField!
    
    var wordToEdit: Word?
    
    weak var delegate: WordDetailViewControllerDelegate?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        if let word = wordToEdit {
            title = "Edit Word"
            wordTextField.text = word.text
            clueTextField.text = word.clue
        } else {
            title = "Add Word"
        }
        
        wordTextField.delegate = self
        clueTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        wordTextField.becomeFirstResponder()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            wordTextField.becomeFirstResponder()
        } else {
            clueTextField.becomeFirstResponder()
        }
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

}

extension WordDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
