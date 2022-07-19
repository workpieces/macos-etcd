//
//  ETCDDrawerView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/19.
//

import SwiftUI

struct ETCDDrawerView: View {
    @EnvironmentObject var menuData: ETCDMenuDrawModel
    // Animation
    var animation: Namespace.ID
    var body: some View {
        VStack {
            HStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                Spacer()
                if menuData.showDrawer {
                    ETCDDrawerCloseButton(animation: animation)
                }
            }
            .padding()
            VStack(alignment: .leading, spacing: 10, content: {
                Text("etcdWP")
                    .font(.title)
                    .fontWeight(.heavy)
            })
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 5)
            VStack(spacing: 22) {
                ETCDDrawerMenuButton(name: "Home", image: "envelope.fill", selectedMenu: $menuData.selectedMenu, animation: animation)
                ETCDDrawerMenuButton(name: "About", image: "bag.fill", selectedMenu: $menuData.selectedMenu, animation: animation)
            }
            .padding(.leading)
            .frame(width: 250, alignment: .leading)
            .padding(.top, 30)
            Divider()
                .background(Color.white)
                .padding(.top, 30)
                .padding(.horizontal, 25)
            Spacer()
        }
        .frame(width: 250,height: UIScreen.main.bounds.height - 88)
        .background(
            Color(hex: "#5B9BD4").opacity(0.30)
                .ignoresSafeArea(.all, edges: .vertical)
        )
    }
}
