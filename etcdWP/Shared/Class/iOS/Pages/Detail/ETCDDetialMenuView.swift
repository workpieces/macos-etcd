//
//  ETCDDetialMenuView.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/8/2.
//

import SwiftUI
import SwiftUIRouter
struct ETCDDetialMenuViewItemView: View {
    var menu:ETCDKVMenuModel
    var body: some View {
        NavLink(to:ClusterLisRouterName) {
            Text("study swiftui")
                .font(.title)
                .fontWeight(.semibold)
                .frame(height: 40)
                .padding(.trailing,8)
                .padding(.leading,8)
                .background(Color.red)
                .cornerRadius(5)
                .listRowBackground(Color(hex: "#262626"))
        }

    }
}

struct ETCDDetialMenuView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("操作")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .opacity(0.75)
                .padding(.leading,20)
                .frame(alignment: .leading)
            Divider().frame(height:0.5)
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(0 ..< menuModels.count){ index in
                        ETCDDetialMenuViewItemView(menu:menuModels[index])
                    }
                }
            }.frame(height: 44)
        }
    }
    
}
