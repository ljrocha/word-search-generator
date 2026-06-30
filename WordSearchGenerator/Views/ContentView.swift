//
//  ContentView.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/27/26.
//  Copyright © 2026 Leandro Rocha. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // TODO: Add badge when Settings are updated. Only when displaying a word search.
            Tab("Word Lists", systemImage: "list.bullet") {
                AllListsView()
            }
            
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
