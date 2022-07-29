//
//  ETCDRootViewControllView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/23.
//

import SwiftUI
import AxisTabView

struct ETCDRootViewControllView: View {
    var constant = ATConstant(axisMode: .bottom, screen: .init(activeSafeArea: false), tab: .init())
    @State private var selection :Int = 0
    var body: some View {
        GeometryReader { proxy in
            AxisTabView(selection: $selection, constant: constant) { state in
                SwiftUILearningCapacityTabBarCustomCenterStyle(state, color: Color(hex:"#262626"), radius: 70, depth: 0.85)
            } content: {
                
                ETCDTabBarContenView(constant:constant,name: "Home",  systemName: "house",tag: 0, safeArea: proxy.safeAreaInsets, content: {
                    SwiftUILearningCapacityHomeController()
                })
                
                ETCDTabBarContenView(constant:constant,  systemName: "plus.circle.fill",tag:  2, safeArea: proxy.safeAreaInsets, content: {
                    
                    ETCDPushController {
                        selection = 0
                    }
                })
                ETCDTabBarContenView(constant:constant,name: "About",  systemName: "info.circle",tag: 1, safeArea: proxy.safeAreaInsets, content: {
                    ETCDiPhoneAboutController()
                })
            }
        }
    }
}
