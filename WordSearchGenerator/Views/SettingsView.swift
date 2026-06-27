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
        NavigationStack {
            Form {
                Section {
                    Toggle("Display title", isOn: $shouldDisplayTitle)
                    Toggle("Draw grid lines", isOn: $shouldDrawGridLines)
                    Toggle("Include word list", isOn: $shouldIncludeWordList)
                    
                    HStack {
                        Stepper("Size: \(size)x\(size)", value: $size, in: 8...14)
                    }
                    
                    Picker(selection: $difficulty) {
                        Text("Easy").tag(Difficulty.easy)
                        Text("Medium").tag(Difficulty.medium)
                        Text("Hard").tag(Difficulty.hard)
                    } label: {
                        Text("Difficulty")
                    }
                } header: {
                    Text("Word Search")
                } footer: {
                    let messageString = """
                                        Easy: Horizontal and vertical word placement with words spelled in a forward direction.\n
                                        Medium: Horizontal and vertical word placement with words spelled in either forward or reverse direction.\n
                                        Hard: Horizontal, vertical, and diagonal word placement with words spelled in either forward or reverse direction.
                                        """
                    Text(messageString)
                }
                
                Section {
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
                } header: {
                    Text("Support")
                } footer: {
                    if let version = UIApplication.appVersion {
                        Text("Version: \(version)")
                    }
                }
            }
            .navigationTitle(Text("Settings"))
        }
    }
}

#Preview {
    SettingsView()
}
