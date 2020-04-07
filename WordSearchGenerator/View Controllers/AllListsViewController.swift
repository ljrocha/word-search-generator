//
//  ViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 3/4/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    var dataModel: DataModel!

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Configuration methods
    func configureViewController() {
        title = "Word Lists"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordList", for: indexPath)
        
        let wordList = dataModel.lists[indexPath.row]
        cell.textLabel?.text = wordList.title
        cell.detailTextLabel?.text = wordList.wordCountDescription
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wordListVC = storyboard?.instantiateViewController(withIdentifier: "WordListViewController") as? WordListViewController {
            wordListVC.wordList = dataModel.lists[indexPath.row]
            
            navigationController?.pushViewController(wordListVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let detailVC = ListDetailViewController()
        detailVC.wordListToEdit = dataModel.lists[indexPath.row]
        detailVC.delegate = self
        
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
    
    // MARK: - Actions
    @objc func addTapped() {
        let detailVC = ListDetailViewController()
        detailVC.delegate = self
        
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }

}

extension AllListsViewController: ListDetailViewControllerDelegate {
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding wordList: WordList) {
        dataModel.lists.append(wordList)
        dataModel.sortWordLists()
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing wordList: WordList) {
        dataModel.sortWordLists()
        tableView.reloadData()
        dismiss(animated: true)
    }
}
