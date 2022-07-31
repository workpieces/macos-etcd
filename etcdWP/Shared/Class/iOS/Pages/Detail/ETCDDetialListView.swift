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
        VStack(){
            ETCDDetialHeadView().frame(height: 70)
            Divider().frame(height: 0.5)
            Spacer()
            ETCDDetialLogView().frame(height:180).background(Color.yellow)
        }
 
    }
}
