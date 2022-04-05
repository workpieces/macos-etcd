//
//  etcdApp.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/10.
//
// App icon: https://appicon.co/
// Macos Icon https://icons8.com/icons/set/mac-app
import SwiftUI

struct EtcdCommands: Commands {
    var body: some Commands {
        SidebarCommands()
    }
}

@main
struct ETCDApp: App {
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