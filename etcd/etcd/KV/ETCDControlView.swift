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
    
    private var backgroundColor: Color {
        let colors = [Color(hex: "#0295A76"), Color(hex: "#7FACAA"), Color(hex: "#EBF4CC"), Color(hex: "#E79875"), Color(hex: "#BA523C"), Color(hex: "#295A76")]
        guard selection <= colors.count - 1 else { return Color(hex: "#295A76")}
        return colors[selection].opacity(0.2)
    }
    
    var body: some View {
        ZStack {
           Text("\(selection)")
        }
        .tabItem(tag: tag, normal: {
            ETCDTabBarItem(constant: $constant, selection: $selection, tag: tag, isSelection: false, systemName: systemName,systemTitle: systemTitle)
        }, select: {
            ETCDTabBarItem(constant: $constant, selection: $selection, tag: tag, isSelection: true, systemName: systemName,systemTitle: systemTitle)
        })
    }
    
}

