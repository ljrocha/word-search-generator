//
//  QuickWSViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 7/11/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class QuickPuzzleViewController: UIViewController {
    
    @IBOutlet weak var listNameTextField: UITextField!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var clueTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var clearButtonItem: UIBarButtonItem!
    
    var wordList = WordList()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Quick Word Puzzle"
        navigationController?.navigationBar.prefersLargeTitles = true
        clearButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearTapped))
        clearButtonItem.isEnabled = false
        navigationItem.leftBarButtonItem = clearButtonItem
        
        tableView.dataSource = self
        tableView.delegate = self
        
        listNameTextField.delegate = self
        wordTextField.delegate = self
        clueTextField.delegate = self
        
        let button = WordSearchButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(wordSearchButtonTapped), for: .touchUpInside)
        view.addSubview(button)
        
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -70).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
    }
    
    // MARK: - Action methods
    @objc func clearTapped() {
        wordList.words.removeAll()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        
        clearButtonItem.isEnabled = false
    }
    
    @objc func wordSearchButtonTapped(_ sender: UIButton) {
        if let wordSearchVC = storyboard?.instantiateViewController(withIdentifier: "WordSearchViewController") as? WordSearchViewController {
            wordSearchVC.wordList = wordList
            
            navigationController?.pushViewController(wordSearchVC, animated: true)
        }
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let clue = clueTextField.text else { return }
        
        let indexPath = IndexPath(row: wordList.words.count, section: 0)
        let word = Word(word: wordTextField.text!, clue: clue)
        wordList.words.append(word)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        wordTextField.text = ""
        clueTextField.text = ""
        
        submitButton.isEnabled = false
        clearButtonItem.isEnabled = true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

extension QuickPuzzleViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        let word = wordList.words[indexPath.row]
        cell.textLabel?.text = word.text
        cell.detailTextLabel?.text = word.clue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        wordList.words.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "WordDetailViewController") as? WordDetailViewController {
            detailVC.wordToEdit = wordList.words[indexPath.row]
            detailVC.delegate = self
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension QuickPuzzleViewController: WordDetailViewControllerDelegate {
    func wordDetailViewControllerDidCancel(_ controller: WordDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishAdding word: Word) {
        // Empty
    }
    
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishEditing word: Word) {
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
}

extension QuickPuzzleViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === wordTextField {
            let oldText = textField.text!
            let stringRange = Range(range, in: oldText)!
            let newText = oldText.replacingCharacters(in: stringRange, with: string)
            
            submitButton.isEnabled = !newText.isEmpty
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField === wordTextField {
            submitButton.isEnabled = false
        }
        
        return true
    }
}
