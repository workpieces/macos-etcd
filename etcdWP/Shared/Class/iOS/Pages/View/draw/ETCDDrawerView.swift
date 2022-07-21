//
//  ETCDDrawerView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/19.
//

import SwiftUI

struct ETCDDrawerView: View {
    @EnvironmentObject var menuData: ETCDMenuDrawModel
    @StateObject var  tableData = HomeTabSelectModel()
    // Animation
    var animation: Namespace.ID
    var body: some View {
        VStack(alignment: .leading) {
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
            .padding(.top,20)
            .padding(.leading,20)
            Text("etcdWP")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity,alignment:.leading)
                .padding(.leading, 20)
            VStack(alignment: .leading) {
                ETCDDrawerMenuButton(name: "Home", image: "house", selectedMenu: $menuData.selectedMenu, animation: animation)
                ETCDDrawerMenuButton(name: "About", image: "info.circle", selectedMenu: $menuData.selectedMenu, animation: animation)
            }
            .padding(.leading,20)
            .padding(.top, 30)
            Spacer()
            Text("Version: \(tableData.getVersion())")
                .withDefaultContentTitle()
                .padding(.bottom,44)
                .padding(.leading,20)
        }
        .frame(width:180,height: UIScreen.main.bounds.height - 88)
        .background(
            Color(hex:"#5B9BD4").opacity(0.10)
                .ignoresSafeArea(.all, edges: .vertical)
        )
    }
}
