//
//  etcdWPApp.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/8.
//

import SwiftUI
import AppKit
// App icon: https://appicon.co/
// Macos Icon https://icons8.com/icons/set/mac-app

struct EtcdCommands: Commands {
    var body: some Commands {
        SidebarCommands()
    }
}



// copy from https://stackoverflow.com/questions/64993265/swiftui-and-appkit-use-close-dialog-to-ask-if-the-app-is-allowed-to-quit
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        print("Application Should Terminate After Last WindowClosed")
        return true
    }
}

@main
struct ETCDApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ETCDHomeContentView()
        }
        // hide window title
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            EtcdCommands()
        }
    }
}
