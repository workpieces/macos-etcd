//
//  etcdWPApp.swift
//  Shared
//
//  Created by FaceBook on 2022/5/2.
//

import SwiftUI
import SwiftUIRouter
#if TARGET_OS_MAC
import AppKit
import GoogleMobileAds
#else

#endif


// App icon: https://appicon.co/
// Macos Icon https://icons8.com/icons/set/mac-app
// SwiftUI基础知识：https://www.jianshu.com/u/c505aa9e47c2

struct EtcdCommands: Commands {
    var body: some Commands {
        SidebarCommands()
    }
}


// copy from https://stackoverflow.com/questions/64993265/swiftui-and-appkit-use-close-dialog-to-ask-if-the-app-is-allowed-to-quit
#if os(macOS)
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        print("Application Should Terminate After Last WindowClosed")
        return true
    }

}
#else

final class AppDelegate: NSObject, UIApplicationDelegate {
    
}
#endif



@main
struct etcdWPApp: App {
    
    @StateObject var homeData = HomeViewModel()
    @EnvironmentObject private var navigator: Navigator
#if os(macOS)
    var screen = NSScreen.main!.visibleFrame
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
#endif
    var body: some Scene {
        WindowGroup {
            Router {
                ETCDHomeContentView()
                #if os(macOS)
                .frame(minWidth: screen.width/1.8, minHeight: screen.height/1.2)
                #endif
            }.environmentObject(homeData)
            .ignoresSafeArea(.all,edges: .all)
            .preferredColorScheme(.dark)
        }
  
#if os(macOS)
        .windowStyle(.hiddenTitleBar)
#endif
        .commands {
            EtcdCommands()
        }
    }
}
