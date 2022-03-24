//
//  NavagationTitle.swift
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

extension View{
    func withDefaultNavagationTitle() -> some View {
        modifier(DefaultNavagationModifier())
    }
}


