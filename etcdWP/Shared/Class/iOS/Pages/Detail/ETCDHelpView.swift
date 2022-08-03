//
//  ETCDHelpView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/30.
//

import SwiftUI
import SwiftUIRouter
struct ETCDHelpRightView: View {
    var body: some View {
        Button(action: {
            UIApplication.shared.open(URL.init(string: DefaultOfficialWebsite)!)
        }, label: {
            Text("访问官网")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }).padding(.trailing,20)
    }
}


struct ETCDHelpLeftView: View {
    var body: some View {
        HStack{
            Button {
                UIApplication.shared.open(URL.init(string: DefaultFeedback)!)
            } label: {
                Text("意见反馈")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }.padding(.leading,5)
        }
    }
}

