//
//  ETCDTabBarContenView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI
import AxisTabView

struct ETCDTabBarContenView<Content:View> : View {
    var constant: ATConstant
    var name : String?
    let tag: Int
    let systemName: String
    let safeArea: EdgeInsets
    let content: Content
    
    init(constant: ATConstant ,name:String = "",systemName:String,tag:Int,safeArea:EdgeInsets,@ViewBuilder content: () -> Content) {
        self.name = name
        self.constant = constant
        self.systemName = systemName
        self.safeArea = safeArea
        self.tag = tag
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { proxy in
            content
                .padding(.bottom,constant.tab.normalSize.height + safeArea.bottom)
        }
        .tabItem(tag: tag, normal: {
            ETCDTabBarItemView(isSelection: false, systemName: systemName,name: name ?? "")
        }, select: {
            ETCDTabBarItemView( isSelection: true, systemName: systemName,name:name ?? "")
        })
    }
}
