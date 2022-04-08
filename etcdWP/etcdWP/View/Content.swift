//
//  ContentTitle.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/24.
//

import SwiftUI

// 全局设置导航栏文字及其高度
struct DefaultNavagationModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(size: 30.0,weight: .semibold))
            .foregroundColor(.white)
            .frame(height: 40.0, alignment: .leading)
            .lineLimit(1)
    }
}

// 默认文本主题字体设置
struct DefaultContentModifier: ViewModifier{
    let fontColor : Color
    let fontSize: CGFloat
    func body(content: Content) -> some View {
        content
            .foregroundColor(fontColor)
            .font(.system(size: fontSize,weight: .semibold))
    }
}

// 默认文本子标题全局字体设置
struct DefaultSubContentModifier: ViewModifier{
    let fontColor : Color
    let fontSize: CGFloat
    func body(content: Content) -> some View {
        content
            .foregroundColor(fontColor)
            .font(.system(size: fontSize,weight: .semibold))
            .lineSpacing(8.0)
            .truncationMode(.middle)
    }
}

extension View {
    func withDefaultNavagationTitle() -> some View {
        modifier(DefaultNavagationModifier())
    }
    
    func withDefaultContentTitle(fontColor: Color = .white,fontSize: CGFloat = 16.0) -> some View {
        modifier(DefaultContentModifier(fontColor: fontColor, fontSize: fontSize))
    }
    
    func withDefaultSubContentTitle(fontColor: Color = .white,fontSize: CGFloat = 12.0) -> some View {
        modifier(DefaultSubContentModifier(fontColor: fontColor, fontSize: fontSize))
    }
}

extension Image {
    func withDefaultImage(foreColor: Color = .white,width: CGFloat = 30.0) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(foreColor)
            .frame(width: width)
   }
}
