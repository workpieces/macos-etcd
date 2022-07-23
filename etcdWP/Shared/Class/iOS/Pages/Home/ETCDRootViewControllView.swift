//
//  ETCDRootViewControllView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/23.
//

import SwiftUI
import AxisTabView

struct ETCDRootViewControllView: View {
    @State private var selection: Int = 0
    @State private var constant = ATConstant(axisMode: .bottom, screen: .init(activeSafeArea: false), tab: .init())
    @State private var radius: CGFloat = 70
    @State private var concaveDepth: CGFloat = 0.85
    @State private var color: Color = Color(hex: "#262626")
    var body: some View {
        GeometryReader { proxy in
            AxisTabView(selection: $selection, constant: constant) { state in
                ETCDCustomCenterStyle(state, color: color, radius: radius, depth: concaveDepth)
            } content: {
                ETCDControlView(selection: $selection, constant: $constant, radius: $radius, concaveDepth: $concaveDepth, color: $color,name: "Home", tag: 0, systemName: "house", safeArea: proxy.safeAreaInsets)
                ETCDControlView(selection: $selection, constant: $constant, radius: $radius, concaveDepth: $concaveDepth, color: $color,tag: 2, systemName: "plus.circle.fill", safeArea: proxy.safeAreaInsets)
                ETCDControlView(selection: $selection, constant: $constant, radius: $radius, concaveDepth: $concaveDepth, color: $color,name: "About", tag: 3, systemName: "info.circle", safeArea: proxy.safeAreaInsets)
            }
        }
        .animation(.easeInOut, value: radius)
        .animation(.easeInOut, value: concaveDepth)
    }
}

fileprivate
struct ETCDControlView: View {
    
    @Binding var selection: Int
    @Binding var constant: ATConstant
    @Binding var radius: CGFloat
    @Binding var concaveDepth: CGFloat
    @Binding var color: Color
    var name : String = ""
    let tag: Int
    let systemName: String
    let safeArea: EdgeInsets
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex:"#262626"))
                .ignoresSafeArea()
            if name  == "About" {
                ETCDAboutViewControlleView()
                    .padding()
                    .padding(.bottom,constant.tab.normalSize.height + safeArea.bottom)
            }else{
                ScrollView {
                    Text("text")
                        .padding()
                        .padding(.bottom,constant.tab.normalSize.height + safeArea.bottom)
                }
            }
        }
        .tabItem(tag: tag, normal: {
            ETCDTabButton(selection: $selection, tag: tag, isSelection: false, systemName: systemName,name: name,constant: $constant)
        }, select: {
            ETCDTabButton(selection: $selection, tag: tag, isSelection: true, systemName: systemName,name:name,constant: $constant)
        })
    }
}

fileprivate
struct ETCDTabButton: View {
    
    @Binding var selection: Int
    let tag: Int
    let isSelection: Bool
    let systemName: String
    let name:String
    @Binding var constant: ATConstant
    @State private var y: CGFloat = 0
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


public struct ETCDCustomCenterStyle: ATBackgroundStyle {
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

struct ETCDRootViewControllView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDRootViewControllView()
    }
}
