//
//  QuickWSViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 7/11/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class QuickWSViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var wordList = WordList()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Quick Word Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let button = WordSearchButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(wordSearchButtonTapped), for: .touchUpInside)
        view.addSubview(button)
        
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -70).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    @objc func clearTapped() {
        wordList.words.removeAll()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    @objc func addTapped() {
        let ac = UIAlertController(title: "Enter new word...", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.autocapitalizationType = .words
            textField.placeholder = "Word"
        }
        ac.addTextField { textField in
            textField.autocapitalizationType = .sentences
            textField.placeholder = "Clue (optional)"
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            
            let word = Word(word: text, clue: "")
            if let clue = ac?.textFields?[1].text {
                word.clue = clue
            }
            
            self?.wordList.words.insert(word, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
            
        })
        
        present(ac, animated: true)
    }
    
    @objc func wordSearchButtonTapped(_ sender: UIButton) {
        if let wordSearchVC = storyboard?.instantiateViewController(withIdentifier: "WordSearchViewController") as? WordSearchViewController {
            wordSearchVC.wordList = wordList
            
            navigationController?.pushViewController(wordSearchVC, animated: true)
        }
    }

}

extension QuickWSViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let word = wordList.words[indexPath.row]
        let ac = UIAlertController(title: "Edit word...", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.autocapitalizationType = .words
            textField.placeholder = "Word"
            textField.text = word.text
        }
        ac.addTextField { textField in
            textField.autocapitalizationType = .sentences
            textField.placeholder = "Clue (optional)"
            textField.text = word.clue
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text, !text.isEmpty else { return }
            
            word.text = text
            if let clue = ac?.textFields?[1].text {
                word.clue = clue
            }
            
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            
        })
        
        present(ac, animated: true)
    }
}
