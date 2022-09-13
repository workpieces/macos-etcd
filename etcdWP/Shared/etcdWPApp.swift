//
//  etcdWPApp.swift
//  Shared
//
//  Created by FaceBook on 2022/5/2.
//

import SwiftUI
import SwiftUIRouter

#if os(macOS)
import AppKit
#else
import GoogleMobileAds
import Alamofire
import AdSupport
import AppTrackingTransparency
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
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                if (status == .authorized) {
                    let idfa =  ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    print("隐私\(idfa)");
                } else {
                    print("请在设置-隐私-广告中打开广告跟踪功能")
                }
            }

        } else {
            // iOS14以下版本依然使用老方法
            // 判断在设置-隐私里用户是否打开了广告跟踪
            if (ASIdentifierManager.shared().isAdvertisingTrackingEnabled) {
                let idfa =  ASIdentifierManager.shared().advertisingIdentifier.uuidString
                print("隐私\(idfa)");
            } else {
            print("请在设置-隐私-广告中打开广告跟踪功能")
            }
        }

        ETCDReachabilityManage.mannger.netWorkReachability { stats in
   
        }
        return true
    }
}
#endif



@main
struct etcdWPApp: App {
    @StateObject var homeData = HomeViewModel()
#if os(macOS)
    var screen = NSScreen.main!.visibleFrame
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
#else
    var screen = UIScreen.main.bounds
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
#endif
    
    var body: some Scene {
        WindowGroup {
            Router {
#if os(macOS)
                ETCDHomeContentView()
                    .frame(minWidth: screen.width/1.8, minHeight: screen.height/1.2)
#else
                ETCDRootViewControllView()
#endif
            }
            .environmentObject(homeData)
#if os(macOS)
                .ignoresSafeArea(.all,edges: .all)
#endif
                .buttonStyle(.plain)
                .preferredColorScheme(.dark)
                 .background(Color(hex:"#262626").ignoresSafeArea())
        }
#if os(macOS)
        
        .windowStyle(.hiddenTitleBar)
#endif
        .commands {
            EtcdCommands()
        }
    }
}
