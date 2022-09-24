//
//  FlyCodingApp.swift
//  FlyCoding
//
//  Created by SSBun on 2022/9/24.
//  Copyright © 2022 SSBun. All rights reserved.
//

import SwiftUI
import Homepage

@main
struct FlyCodingApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.openURL) var openURL
    
    var body: some Scene {
        WindowGroup("FlyCoding") {
            RootView()
        }.commands {
            CommandGroup(replacing: .help) {
                Button("FlyCoding Document") {
                    openURL(URL(string: "https://github.com/SSBun/FlyCoding/blob/master/README.md")!)
                }
            }
        }
    }
}
