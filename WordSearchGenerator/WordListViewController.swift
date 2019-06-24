//
//  WordListDetailViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class WordListViewController: UITableViewController {
    
    var wordList: WordList!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = wordList.listName
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        let word = wordList.words[indexPath.row]
        cell.textLabel?.text = word.text
        cell.detailTextLabel?.text = word.clue
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "WordDetailViewController") as? WordDetailViewController {
            detailVC.wordToEdit = wordList.words[indexPath.row]
            detailVC.delegate = self
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // MARK: - Actions
    @objc func addTapped() {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "WordDetailViewController") as? WordDetailViewController {
            detailVC.delegate = self
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @objc func wordSearchButtonTapped(_ sender: UIButton) {
        if let wordSearchVC = storyboard?.instantiateViewController(withIdentifier: "WordSearchViewController") as? WordSearchViewController {
            wordSearchVC.wordList = wordList
            
            navigationController?.pushViewController(wordSearchVC, animated: true)
        }
    }
    
}

extension WordListViewController: WordDetailViewControllerDelegate {
    func wordDetailViewControllerDidCancel(_ controller: WordDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishAdding word: Word) {
        wordList.words.append(word)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishEditing word: Word) {
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    
}
