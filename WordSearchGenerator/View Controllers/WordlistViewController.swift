//
//  WordlistDetailViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class WordlistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var wordlist: Wordlist!
    
    var wordSearchButton: WordSearchButton!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = wordlist.title
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        wordSearchButton = WordSearchButton()
        wordSearchButton.translatesAutoresizingMaskIntoConstraints = false
        wordSearchButton.addTarget(self, action: #selector(wordSearchButtonTapped), for: .touchUpInside)
        wordSearchButton.isEnabled = !wordlist.words.isEmpty
        view.addSubview(wordSearchButton)
        
        wordSearchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -70).isActive = true
        wordSearchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    // MARK: - Actions
    @objc func addTapped() {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "WordDetailViewController") as? WordDetailViewController {
            detailVC.delegate = self
            
            let navController = UINavigationController(rootViewController: detailVC)
            present(navController, animated: true)
        }
    }
    
    @objc func wordSearchButtonTapped(_ sender: UIButton) {
        if let wordSearchVC = storyboard?.instantiateViewController(withIdentifier: "WordSearchViewController") as? WordSearchViewController {
            wordSearchVC.wordlist = wordlist
            
            navigationController?.pushViewController(wordSearchVC, animated: true)
        }
    }
    
}

extension WordlistViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordlist.words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        let word = wordlist.words[indexPath.row]
        cell.textLabel?.text = word
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        wordlist.words.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        wordSearchButton.isEnabled = !wordlist.words.isEmpty
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "WordDetailViewController") as? WordDetailViewController {
            detailVC.wordToEdit = wordlist.words[indexPath.row]
            detailVC.delegate = self
            
            let navController = UINavigationController(rootViewController: detailVC)
            present(navController, animated: true)
        }
    }
}

extension WordlistViewController: WordDetailViewControllerDelegate {
    func wordDetailViewControllerDidCancel(_ controller: WordDetailViewController) {
        dismiss(animated: true)
    }
    
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishAdding word: String) {
        guard wordlist.isOriginal(word: word) else {
            showDuplicateWordMessage()
            return
        }
        
        wordlist.words.append(word)
        tableView.reloadData()
        wordSearchButton.isEnabled = true
        dismiss(animated: true)
    }
    
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishEditing word: String) {
        guard wordlist.isOriginal(word: word) else {
            showDuplicateWordMessage()
            return
        }
        
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func showDuplicateWordMessage() {
        let ac = UIAlertController(title: "Duplicate word", message: "Please enter a unique word.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        dismiss(animated: true) { [weak self] in
            self?.present(ac, animated: true)
        }
    }
}
