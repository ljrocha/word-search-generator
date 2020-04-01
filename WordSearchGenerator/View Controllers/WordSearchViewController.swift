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
    
    var pdfView: PDFView!
    
    var wordSearch = WordSearch()
    var wordlist: Wordlist!
    
    private let pdfURL: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("WordSearchPuzzle.pdf")
    }()
    
    // MARK: - Deinitializer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordSearch.wordlist = wordlist
        
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
        view.backgroundColor = .systemBackground

        title = "Word Search Puzzle"
        navigationItem.largeTitleDisplayMode = .never
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(generateNewWordSearchPuzzle))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [share, refresh]
    }
    
    func configurePDFView() {
        pdfView = PDFView()
        pdfView.backgroundColor = .secondarySystemBackground
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
        let pdfData = wordSearch.render()
        try? pdfData.write(to: pdfURL)
        
        if let document = PDFDocument(data: pdfData) {
            pdfView.autoScales = true
            pdfView.document = document
        }
    }
    
    @objc func shareTapped() {
        let ac = UIActivityViewController(activityItems: ["Can you solve this word search puzzle?\n", pdfURL], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @objc func settingsUpdated() {
        generateNewWordSearchPuzzle()
        navigationController?.tabBarItem.badgeValue = "!"
    }

}
