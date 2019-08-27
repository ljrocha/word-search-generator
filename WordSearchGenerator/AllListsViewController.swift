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
        
        title = "Wordlists"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Wordlist", for: indexPath)
        
        let wordlist = dataModel.lists[indexPath.row]
        cell.textLabel?.text = wordlist.title
        cell.detailTextLabel?.text = wordlist.detailedWordCount
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wordlistVC = storyboard?.instantiateViewController(withIdentifier: "WordlistViewController") as? WordlistViewController {
            wordlistVC.wordlist = dataModel.lists[indexPath.row]
            
            navigationController?.pushViewController(wordlistVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as? ListDetailViewController {
            detailVC.wordlistToEdit = dataModel.lists[indexPath.row]
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
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding wordlist: Wordlist) {
        dataModel.lists.append(wordlist)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing wordlist: Wordlist) {
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}
