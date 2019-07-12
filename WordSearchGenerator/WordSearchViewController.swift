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
    
    var wordList: WordList!
    
    var pdfView: PDFView!
    private let url = getDocumentsDirectory().appendingPathComponent("output.pdf")
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Word Search Puzzle"
        navigationItem.largeTitleDisplayMode = .never
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(newWordSearchPuzzle))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItems = [share, refresh]
        
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        newWordSearchPuzzle()
    }
    
    // MARK: - Actions
    @objc func newWordSearchPuzzle() {
        let wordSearch = WordSearch()
        wordSearch.words = wordList.words
        
        let output = wordSearch.render()
        try? output.write(to: url)
        
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
    }
    
    @objc func shareTapped() {
        let ac = UIActivityViewController(activityItems: ["Checkout these word puzzles\n", url], applicationActivities: nil)
        present(ac, animated: true)
    }

}
