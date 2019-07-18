//
//  AppDelegate.swift
//  FlyCoding
//
//  Created by SSBun on 19/09/2017.
//  Copyright © 2017 SSBun. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func gotoHelp(_ sender: Any) {
        guard let url = URL(string: "https://github.com/SSBun/FlyCoding/blob/master/README.md") else {return}
        NSWorkspace.shared.open(url)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}


