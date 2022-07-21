//
//  ETCDDrawerMenuButton.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/19.
//

import SwiftUI

struct ETCDDrawerMenuButton: View {
    
    var name: String
    var image: String
    @Binding var selectedMenu: String
    var animation: Namespace.ID
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedMenu = name
            }
        }, label: {
            HStack() {
                Image(systemName: image)
                    .font(.title2)
                    .foregroundColor(selectedMenu == name ? .white : .gray)
                Text(LocalizedStringKey(name))
                    .foregroundColor(selectedMenu == name ? .white : .gray)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .frame(width: 120, alignment: .leading)
            .background(
                ZStack {
                    if selectedMenu == name {
                        Color.primary.opacity(0.15)
                            .cornerRadius(10)
                            .matchedGeometryEffect(id: "TabMenu", in: animation)
                    } else {
                        Color.clear
                    }
                }
            )
        })
    }
}
