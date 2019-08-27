//
//  Functions.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 8/27/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
