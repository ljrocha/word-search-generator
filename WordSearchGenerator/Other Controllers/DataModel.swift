//
//  DataModel.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 7/15/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import Foundation

class DataModel {
    
    var lists = [WordList]()
    
    // MARK: - Initialization
    init() {
        loadWordLists()
    }
    
    // MARK: - Data persistance
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath() -> URL {
        return getDocumentsDirectory().appendingPathComponent("WordLists.json")
    }
    
    func saveWordLists() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(lists)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding wordList array: \(error.localizedDescription)")
        }
    }
    
    func loadWordLists() {
        if let data = try? Data(contentsOf: dataFilePath()) {
            let jsonDecoder = JSONDecoder()
            
            do {
                lists = try jsonDecoder.decode([WordList].self, from: data)
                sortWordLists()
                lists.forEach { $0.sortWords() }
            } catch {
                print("Error decoding wordList array: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Methods
    func sortWordLists() {
        lists.sort {
            return $0.title.localizedStandardCompare($1.title) == .orderedAscending
        }
    }
}
