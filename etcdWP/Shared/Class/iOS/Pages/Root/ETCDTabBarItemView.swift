//
//  ETCDTabBarItemView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI
import AxisTabView

struct ETCDTabBarItemView: View {
    let isSelection: Bool
    let systemName: String
    let name:String
    @Binding var selection: Int
    var body: some View {
        if  (systemName == "plus.circle.fill"){
            ZStack(alignment: .leading) {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 24))
                    .padding(10)
                    .frame(width: 65, height: 65)
            }
            .foregroundColor(isSelection ? .white : Color.white.opacity(0.75))
            .background(Color(hex:"#00FFFF").opacity(0.55))
            .clipShape(Capsule())
            .offset(y: -20)
        }else {
            VStack() {
                Image(systemName: systemName)
                    .font(.system(size: 20))
                    .foregroundColor(isSelection ? .white : .gray)
                    .padding(.bottom,1)
                Text(LocalizedStringKey(name))
                    .foregroundColor(isSelection ? .white : .gray)
                    .font(.system(size: 15))
            }.offset(y: 10)
            
        }
    }
}


struct ETCDTabBarCustomCenterStyle: ATBackgroundStyle {
    public var state: ATTabState
    public var color: Color = Color(hex:"#262626")
    public var radius: CGFloat = 80
    public var depth: CGFloat = 0.8
    public init(_ state: ATTabState, color: Color, radius: CGFloat, depth: CGFloat) {
        self.state = state
        self.color = color
        self.radius = radius
        self.depth = depth
    }
    
    public var body: some View {
        let tabConstant = state.constant.tab
        GeometryReader { proxy in
            ATCurveShape(radius: radius, depth: depth, position: 0.5)
                .fill(color)
                .frame(height: tabConstant.normalSize.height + state.safeAreaInsets.bottom)
                .scaleEffect(CGSize(width: 1, height: 1))
                .mask(
                    Rectangle()
                        .frame(height: proxy.size.height + 100)
                )
                .shadow(color:Color.primary.opacity(0.15),
                        radius: tabConstant.shadow.radius,
                        x: tabConstant.shadow.x,
                        y: tabConstant.shadow.y)
        }
        .animation(.easeInOut, value: state.currentIndex)
    }
}
