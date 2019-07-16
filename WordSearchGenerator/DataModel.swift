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
    
    init() {
        loadWordLists()
    }
    
    // MARK: - Data persistance
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return getDocumentsDirectory().appendingPathComponent("WordLists.json")
    }
    
    func saveWordLists() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(lists)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            print("Error encoding wordlist array: \(error.localizedDescription)")
        }
    }
    
    func loadWordLists() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let jsonDecoder = JSONDecoder()
            
            do {
                lists = try jsonDecoder.decode([WordList].self, from: data)
            } catch {
                print("Error decoding wordlist array: \(error.localizedDescription)")
            }
        }
    }
}
