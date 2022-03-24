//
//  TabbarItemButton.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/24.
//

import SwiftUI

struct DefaultTabarButtonViewModifier: ViewModifier{
    let imageName: String
    let title: String
    let imageSize : CGFloat
    let titleFontSize: CGFloat
    
    func body(content: Content) -> some View {
        VStack(spacing: 8.0){
            Image(systemName: imageName)
                .font(.system(size: imageSize, weight: .semibold))
            Text(title)
                .fontWeight(.semibold)
                .font(.system(size: titleFontSize))
        }
    }
}

extension View {
    func withDefaultTabarButton(imageName: String,title: String,imageSize: CGFloat = 18,fontSize: CGFloat = 12) -> some View {
        modifier(DefaultTabarButtonViewModifier(imageName: imageName, title: title, imageSize: imageSize, titleFontSize: fontSize))
    }
}
