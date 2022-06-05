//
//  ETCDKVOperateContentView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI

struct ETCDKVOperateContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    var body: some View {
        GeometryReader {  g in
            HStack {
                ETCDMakeOperateKvTextContentView(text:storeObj.realeadData.currentKv?.value ?? "")
                    .frame(width: g.size.width/2)
                Spacer()
                ETCDEtcdOperationView()
                    .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                    .frame(width: g.size.width/2)
                Spacer()
            }
        }
    }
}



struct ETCDKVOperateContentView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDKVOperateContentView()
    }
}
