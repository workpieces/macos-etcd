//
//  TabbarItemButton.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/24.
//

import SwiftUI

// 设置默认左侧点击按钮
struct DefaultTabarButtonViewModifier: ViewModifier{
    var image: String
    var title: String
    @Binding var selectTab : String
    
    func body(content: Content) -> some View {
        Button {
            withAnimation {
                selectTab = title
            }
        } label: {
            VStack(spacing: 8.0){
                Image(systemName: image)
                    .withDefaultContentTitle()
                    .foregroundColor(selectTab == title ? .white : .gray)
                Text(title)
                    .withDefaultSubContentTitle()
                    .foregroundColor(selectTab == title ? .white : .gray)
            }
        }
        .padding(.vertical,8.0)
        .frame(width: DefaultTabbarButtonHeight)
        .contentShape(Rectangle())
        .buttonStyle(PlainButtonStyle())
        .background(Color.primary.opacity(selectTab == title ? 0.15 : 0))
        .cornerRadius(DefaultRadius)
    }
}

extension View {
    func withDefaultTabarButton(imageName: String,title: String,selectTab: Binding<String>) -> some View {
        modifier(DefaultTabarButtonViewModifier(image: imageName, title: title, selectTab: selectTab))
    }
}
