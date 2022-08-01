//
//  ETCDDetialListView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/31.
//

import SwiftUI

struct ETCDDetialListView: View {
    @EnvironmentObject var storeObj : ItemStore
    var body: some View {
        GeometryReader { proxy in
            VStack(){
                ETCDDetialHeadView().frame(height: 70)
                Divider().frame(height: 0.5)
                Text("fdasfdaf").frame(height:proxy.size.height * 0.6)
                ETCDDetialLogView().frame(height:proxy.size.height * 0.3)
            }
        }

    }
}
