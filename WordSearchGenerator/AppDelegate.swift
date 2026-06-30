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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerDefaults()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveData()
    }

    // MARK: - Helper methods
    func saveData() {
        dataModel.saveWordLists()
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

