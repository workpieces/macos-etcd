//
//  ETCDKeyListContentView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI
import PopupView
import Combine
import FilePicker
import ObjectMapper

struct ETCDKeyListContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    var body: some View {
        VStack {
            if storeObj.showFormat == .List{
                ETCDKeyListContentListView()
                ETCDKeyListContentPageView()
            }else{
                ETCDKeyListContentTreeListView()
                ETCDKeyTreeListContentPageView()
            }
            ETCDKeyContentMembersListView()
        }.onAppear(perform: {
            storeObj.KVReaload(false)
        })
    }
}
