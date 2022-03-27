//
//  ETCDControlView.swift
//  etcd
//
//  Created by FaceBook on 2022/3/27.
//  Copyright © 2022 Workpiece. All rights reserved.
//

import SwiftUI
import AxisTabView

struct ETCDControlView: View {
    
    @Binding var selection: Int
    @Binding var constant: ATConstant
    @Binding var color: Color
    
    let tag: Int
    let systemName: String
    let systemTitle:String
    let safeArea: EdgeInsets
    
    var body: some View {
        ZStack {
            switch selection {
            case 0:
//                List(items, id: \.self, children: \.children, selection: $selection) { item in
//
//                }
//                .listStyle(SidebarListStyle())
                EmptyView()
            case 1:
                Text("\(selection)")
            case 2:
                Text("\(selection)")
            default:
                EmptyView()
            }
        }
        .tabItem(tag: tag, normal: {
            ETCDTabBarItem(constant: $constant, selection: $selection, tag: tag, isSelection: false, systemName: systemName,systemTitle: systemTitle)
        }, select: {
            ETCDTabBarItem(constant: $constant, selection: $selection, tag: tag, isSelection: true, systemName: systemName,systemTitle: systemTitle)
        })
    }
}

