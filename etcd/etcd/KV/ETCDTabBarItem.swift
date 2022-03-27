//
//  ETCDTabBarItem.swift
//  etcd
//
//  Created by FaceBook on 2022/3/27.
//  Copyright © 2022 Workpiece. All rights reserved.
//

import SwiftUI
import AxisTabView

struct ETCDTabBarItem: View {
    
    @Binding var constant: ATConstant
    @Binding var selection: Int
    let tag: Int
    let isSelection: Bool
    let systemName: String
    let systemTitle:String
    
    @State private var width: CGFloat = 0
    
    var BarItemContent: some View {
        HStack(spacing: 0) {
            Image(systemName:systemName)
                .resizable()
                .scaledToFit()
                .font(.system(size: 20))
                .padding(10)
            if isSelection {
                Text(systemTitle)
                    .lineLimit(1)
            }
        }
        .frame(width: width, height: constant.tab.normalSize.height * 0.75, alignment: .leading)
        .foregroundColor(isSelection ? Color.white : Color.white)
        .background(isSelection ? Color.gray.opacity(0.2) : Color.clear)
        .clipShape(Capsule())
        .onAppear {
            width = constant.tab.normalSize.width
            var maxWidth = constant.tab.selectWidth + 5
            var seletedMaxWidth = constant.tab.selectWidth
            if tag == 0 {
                maxWidth = 80
                seletedMaxWidth = 80
            }
            if isSelection {
                withAnimation(.easeInOut(duration: 0.26)) {
                    width = maxWidth
                }
                withAnimation(.easeInOut(duration: 0.3).delay(0.25)) {
                    width =  seletedMaxWidth
                }
            }else {
                width = constant.tab.normalSize.width
            }
        }
    }
    
    var body: some View {
        BarItemContent
    }
}

