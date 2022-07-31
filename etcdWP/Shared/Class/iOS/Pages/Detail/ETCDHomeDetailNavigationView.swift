//
//  ETCDHomeDetailNavigationView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/31.
//

import SwiftUI

struct ETCDHomeDetailNavigationView: View {
    let title:String
    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .center){
                ETCDHelpLeftView()
                Spacer()
                Text(LocalizedStringKey(title))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(height: 40.0, alignment: .leading)
                    .lineLimit(1)
                Spacer()
                ETCDHelpRightView()
            }.frame(width:proxy.size.width,height:proxy.safeAreaInsets.top)
            
        }
    }
}

