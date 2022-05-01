//
//  etcdWp_iOSApp.swift
//  etcdWp-iOS
//
//  Created by FaceBook on 2022/5/1.
//

import SwiftUI

@main
struct etcdWp_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            ETCDHomeContentView()
                .preferredColorScheme(.dark)
        }
    }
}
