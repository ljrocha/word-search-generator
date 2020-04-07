//
//  UIApplication+AppVersion.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 4/6/20.
//  Copyright © 2020 Leandro Rocha. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static var appVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
