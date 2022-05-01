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
    @EnvironmentObject var homeData: HomeViewModel
    var imageName: String
    var title: String
    @Binding var isLinkActive : Bool
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            Button {
             try!   homeData.OpenALL()
            } label: {
                Text("开启所有服务")
                    .font(.system(size: 10.0))
                    .foregroundColor(.white)
                    .frame(width:70)
            } .frame(alignment: .trailing)
              .buttonStyle(PlainButtonStyle())
              .padding(20)
              .background(Color(hex:"#00FFFF").opacity(0.55))
              .cornerRadius(8)
              .clipped()
            Button {
                try!  homeData.CloseAll()
            } label: {
                Text("停止所有服务")
                    .font(.system(size: 10.0))
                    .foregroundColor(.white)
                    .frame(width:70)
            } .frame(alignment: .trailing)
              .buttonStyle(PlainButtonStyle())
              .padding(20)
              .background(Color(hex:"#00FFFF").opacity(0.55))
              .cornerRadius(8)
              .clipped()
            
            PushView(destination: ETCDConfigView(), isActive: $isLinkActive) {
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
                .background(Color(hex:"#00FFFF").opacity(0.55))
                .cornerRadius(8)
                .clipped()
            }
        }
    }
}

struct DefaultNavagationBackViewModifier: ViewModifier {
    @Binding var isPopView: Bool
    var title : String
    var size : CGFloat
    func body(content: Content) -> some View {
        HStack {
            PopView(isActive: $isPopView ) {
                Button {
                    self.isPopView.toggle()
                } label: {
                    Image(systemName: "arrow.backward")
                        .withDefaultImage(width: 25.0)
                }
                .buttonStyle(PlainButtonStyle())
            }
            Spacer()
            Text(title)
                .withDefaultContentTitle(fontSize: size)
            Spacer()
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
    
    func withDefaultNavagationBack(title: String,size: CGFloat = 30.0,isPop: Binding<Bool>) -> some View {
        modifier(DefaultNavagationBackViewModifier(isPopView: isPop, title: title,size: size))
    }
}
