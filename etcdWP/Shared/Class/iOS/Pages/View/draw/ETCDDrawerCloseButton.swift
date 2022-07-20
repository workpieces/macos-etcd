//
//  ETCDDrawerCloseButton.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/19.
//

import SwiftUI

struct ETCDDrawerCloseButton: View {
    
    @EnvironmentObject var menuData: ETCDMenuDrawModel
    var animation: Namespace.ID
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                menuData.showDrawer.toggle()
            }
        }, label: {
            VStack(spacing: 5) {
                Capsule()
                    .fill(menuData.showDrawer ? Color.white : Color.primary)
                    .frame(width: 35, height: 3)
                    .rotationEffect(Angle(degrees: menuData.showDrawer ? -50 : 0))
                    .offset(x: menuData.showDrawer ? 2 : 0, y: menuData.showDrawer ? 9 : 0)
                VStack(spacing: 5) {
                    Capsule()
                        .fill(menuData.showDrawer ? Color.white : Color.primary)
                        .frame(width: 35, height: 3)
                    
                    Capsule()
                        .fill(menuData.showDrawer ? Color.white : Color.primary)
                        .frame(width: 35, height: 3)
                        .offset(y: menuData.showDrawer ? -8 : 0)
                }
                .rotationEffect(Angle(degrees: menuData.showDrawer ? 50 : 0))
            }
        })
        .padding(.trailing,10)
        .scaleEffect(0.8)
        .matchedGeometryEffect(id: "etcdDraw_button", in: animation)
    }
}
