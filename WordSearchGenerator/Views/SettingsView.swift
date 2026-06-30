//
//  SettingsView.swift
//  WordSearchGenerator
//
//  Created by Leandro Rocha on 6/27/26.
//  Copyright © 2026 Leandro Rocha. All rights reserved.
//

import SwiftUI
import SafariServices

struct SettingsView: View {
    
    // TODO: Store/Read from User Defaults
    @State private var shouldDisplayTitle: Bool = true
    @State private var shouldDrawGridLines: Bool = true
    @State private var shouldIncludeWordList: Bool = true
    @State private var size: Int = 10
    @State private var difficulty: Difficulty = .medium
    
    var body: some View {
        Form {
            Section(header: Text("Word Search")) {
                Toggle("Display title", isOn: $shouldDisplayTitle)
                Toggle("Draw grid lines", isOn: $shouldDrawGridLines)
                Toggle("Include word list", isOn: $shouldIncludeWordList)
                
                HStack {
                    Stepper("Size: \(size)x\(size)", value: $size, in: 8...14)
                }
                
                // TODO: Add explanation of each difficulty
                Picker(selection: $difficulty) {
                    Text("Easy").tag(Difficulty.easy)
                    Text("Medium").tag(Difficulty.medium)
                    Text("Hard").tag(Difficulty.hard)
                } label: {
                    Text("Difficulty")
                }
            }
            
            Section(header: Text("Support")) {
                if let version = UIApplication.appVersion {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(version)
                    }
                }
                
                // TODO: Determine if this is the best way to present Privacy Policy
                if let url = URL(string: "https://github.com/ljrocha/word-search-generator/blob/master/PRIVACY.md") {
                    let safariViewController = SFSafariViewController(url: url)
                    Button {
                        UIApplication.shared.firstKeyWindow?.rootViewController?.present(safariViewController, animated: true)
                    } label: {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Settings"))
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
