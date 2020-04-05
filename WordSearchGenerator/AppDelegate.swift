//
//  AppDelegate.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 3/4/19.
//  Copyright © 2019 Leandro Rocha. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let dataModel = DataModel()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let tabBarController = window!.rootViewController as! UITabBarController
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
        
        registerDefaults()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveData()
    }

    // MARK: - Helper methods
    func saveData() {
        dataModel.saveWordlists()
    }
    
    func registerDefaults() {
        let dictionary = [Key.UserDefaults.gridSize: 10,
                          Key.UserDefaults.difficulty: Difficulty.medium.rawValue,
                          Key.UserDefaults.wordsIncluded: true,
                          Key.UserDefaults.titleIncluded: true,
                          Key.UserDefaults.gridLinesIncluded: true] as [String : Any]
        UserDefaults.standard.register(defaults: dictionary)
    }

}

