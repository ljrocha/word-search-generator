//
//  WordSearchViewController.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/23/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit
import PDFKit

class WordSearchViewController: UIViewController {
    
    var wordlist: Wordlist!
    
    var pdfView: PDFView!
    private let url: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("output.pdf")
    }()
    
    // MARK: - Deinitializer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configurePDFView()
        generateNewWordSearchPuzzle()
        addSettingsUpdatedObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.tabBarItem.badgeValue = nil
    }
    
    // MARK: - Configuration methods
    func configureViewController() {
        view.backgroundColor = .white
        title = "Word Search Puzzle"
        navigationItem.largeTitleDisplayMode = .never
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(generateNewWordSearchPuzzle))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [share, refresh]
    }
    
    func configurePDFView() {
        pdfView = PDFView()
        if #available(iOS 13.0, *) {
            pdfView.backgroundColor = .secondarySystemBackground
        }
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .vertical
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func addSettingsUpdatedObserver() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(settingsUpdated), name: Notification.Name(Key.Notification.settingsUpdated), object: nil)
    }
    
    // MARK: - Actions
    @objc func generateNewWordSearchPuzzle() {
        let wordSearch = WordSearch()
        wordSearch.wordlist = wordlist
        _ = wordSearch.makeGrid()
        
        let output = wordSearch.render()
        try? output.write(to: url)
        
        if let document = PDFDocument(url: url) {
            pdfView.autoScales = true
            pdfView.document = document
        }
    }
    
    @objc func shareTapped() {
        let ac = UIActivityViewController(activityItems: ["Can you complete this word search puzzle?\n", url], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @objc func settingsUpdated() {
        generateNewWordSearchPuzzle()
        navigationController?.tabBarItem.badgeValue = "!"
    }

}
