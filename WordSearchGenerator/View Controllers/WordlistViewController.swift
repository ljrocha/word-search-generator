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
    var wordSearchButton = WSButton()
    
    var wordlist: Wordlist!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureTableView()
        configureWordSearchButton()
    }
    
    // MARK: - Configuration methods
    func configureViewController() {
        title = wordlist.title
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureWordSearchButton() {
        view.addSubview(wordSearchButton)
        wordSearchButton.translatesAutoresizingMaskIntoConstraints = false
        wordSearchButton.addTarget(self, action: #selector(wordSearchButtonTapped), for: .touchUpInside)
        wordSearchButton.isEnabled = !wordlist.words.isEmpty
        
        let padding: CGFloat = 40
        NSLayoutConstraint.activate([
            wordSearchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            wordSearchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            wordSearchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            wordSearchButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Actions
    @objc func addTapped() {
        let detailVC = WordDetailViewController()
        detailVC.delegate = self
        
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
    
    @objc func wordSearchButtonTapped(_ sender: UIButton) {
        let wordSearchVC = WordSearchViewController()
        wordSearchVC.wordlist = wordlist
        
        navigationController?.pushViewController(wordSearchVC, animated: true)
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
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        
        let detailVC = WordDetailViewController()
        detailVC.wordToEdit = wordlist.words[indexPath.row]
        detailVC.delegate = self
        
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
}

extension WordlistViewController: WordDetailViewControllerDelegate {
    
    func wordDetailViewControllerDidCancel(_ controller: WordDetailViewController) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        dismiss(animated: true)
    }
    
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishAdding word: String) {
        guard wordlist.isOriginal(word: word) else {
            showDuplicateWordErrorMessage()
            return
        }
        
        wordlist.words.append(word)
        wordlist.sortWords()
        tableView.reloadData()
        wordSearchButton.isEnabled = true
        dismiss(animated: true)
    }
    
    func wordDetailViewController(_ controller: WordDetailViewController, didFinishEditing word: String) {
        guard wordlist.isOriginal(word: word) else {
            showDuplicateWordErrorMessage()
            return
        }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            wordlist.words[indexPath.row] = word
        }
        wordlist.sortWords()
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func showDuplicateWordErrorMessage() {
        let ac = UIAlertController(title: "Duplicate word", message: "Please enter a unique word.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        presentedViewController?.present(ac, animated: true)
    }
}
