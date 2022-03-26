//
//  TabbarItemButton.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/24.
//

import SwiftUI
import NavigationStack

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

// 创建客户端按钮
struct DefaultAddButtonViewModifier: ViewModifier{
    var imageName: String
    var title: String
    @Binding var isLinkActive : Bool
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            PushView(destination: HomeClientCreateView(), isActive: $isLinkActive) {
                Button {  self.isLinkActive.toggle() } label: {
                    HStack {
                        Image(systemName: imageName)
                            .withDefaultImage(width: 16.0)
                        
                        Text(title)
                            .withDefaultContentTitle()
                    }
                    .padding(DefaultSpacePadding)
                }
                .buttonStyle(PlainButtonStyle())
                .background(Capsule().fill(Color(hex:"#00FFFF").opacity(0.30)))
            }
        }
    }
}

extension View {
    func withDefaultTabarButton(imageName: String,title: String,selectTab: Binding<String>) -> some View {
        modifier(DefaultTabarButtonViewModifier(image: imageName, title: title, selectTab: selectTab))
    }
    
    func withDefaultAddButton(imageName: String,title: String,link: Binding<Bool>) -> some View {
        modifier(DefaultAddButtonViewModifier(imageName: imageName, title: title, isLinkActive: link))
    }
}
