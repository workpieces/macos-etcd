//
//  ETCDHomeTabBarView.swift
//  etcd
//
//  Created by FaceBook on 2022/3/27.
//  Copyright © 2022 Workpiece. All rights reserved.
//

import SwiftUI
import AxisTabView

struct ETCDDetailTabBarView: View {
    @State private var selection: Int = 0
    @State private var constant = ATConstant(axisMode: .bottom, screen: .init(activeSafeArea: false), tab: .init(selectWidth: 130))
    @State private var color: Color = .orange
    var body: some View {
        GeometryReader { proxy in
            AxisTabView(selection: $selection, constant: constant) { state in
                ATBasicStyle(state, color:Color(hex: "#375B7E"))
            } content: {
                ETCDControlView(selection: $selection, constant: $constant, color: $color, tag: 0, systemName: "antenna.radiowaves.left.and.right",systemTitle:"KV" ,safeArea: proxy.safeAreaInsets)
                ETCDControlView(selection: $selection, constant: $constant, color: $color, tag: 1, systemName: "lock.icloud.fill",systemTitle:"Authorize", safeArea: proxy.safeAreaInsets)
                ETCDControlView(selection: $selection, constant: $constant, color: $color, tag: 2, systemName: "person.3",systemTitle:"Members", safeArea: proxy.safeAreaInsets)
            }
        }
        .animation(.easeInOut, value: constant)
    }
}

struct ETCDDetailTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDDetailTabBarView()
    }
}
