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
            Tab("Word Lists", systemImage: "list.bullet") {
                EmptyView()
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
