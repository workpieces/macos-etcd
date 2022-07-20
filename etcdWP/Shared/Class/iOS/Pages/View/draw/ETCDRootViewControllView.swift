//
//  ETCDHomeViewControllView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/19.
//

import SwiftUI

struct ETCDRootViewControllView: View {
    init() {
        UITabBar.appearance().isHidden = true
    }
    @StateObject var menuData = ETCDMenuDrawModel()
    @Namespace var animation
    var body: some View {
        HStack(spacing: 0) {
            ETCDDrawerView(animation: animation)
            // Main View
            TabView(selection: $menuData.selectedMenu) {
                ETCDHomeViewControlleView()
                    .tag("Home")
                ETCDAboutViewControlleView()
                    .tag("About")
            }
            .frame(width: UIScreen.main.bounds.width)
        }

        .frame(width: UIScreen.main.bounds.width)
        .offset(x: menuData.showDrawer ? 125 : -125)
        .overlay(
            ZStack {
                if !menuData.showDrawer {
                    ETCDDrawerCloseButton(animation: animation)
                        .padding()
                }
            }, alignment: .topLeading
        ).padding(.top, 44)
        .environmentObject(menuData)
    }
}
