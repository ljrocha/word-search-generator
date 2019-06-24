//
//  ViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 3/4/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    var wordLists = [WordList]()

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Word Lists"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        let path = Bundle.main.url(forResource: "capitals", withExtension: "json")!
        let contents = try! Data(contentsOf: path)
        let words = try! JSONDecoder().decode([Word].self, from: contents)

        let list1 = WordList(name: "Swift Terms")
        list1.words.append(contentsOf: words)
        wordLists.append(list1)
        
        let list2 = WordList(name: "iOS Concepts")
        list2.words.append(contentsOf: words)
        wordLists.append(list2)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordList", for: indexPath)
        
        let wordList = wordLists[indexPath.row]
        cell.textLabel?.text = wordList.listName
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wordListVC = storyboard?.instantiateViewController(withIdentifier: "WordListViewController") as? WordListViewController {
            wordListVC.wordList = wordLists[indexPath.row]
            
            navigationController?.pushViewController(wordListVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as? ListDetailViewController {
            let wordList = wordLists[indexPath.row]
            detailVC.wordListToEdit = wordList
            detailVC.delegate = self
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // MARK: - Actions
    @objc func addTapped() {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as? ListDetailViewController {
            detailVC.delegate = self
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

}

extension AllListsViewController: ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding wordList: WordList) {
        wordLists.append(wordList)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing wordList: WordList) {
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
