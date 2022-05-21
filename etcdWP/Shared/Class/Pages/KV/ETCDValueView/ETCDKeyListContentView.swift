//
//  ETCDKeyListContentView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI
import NavigationStack
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
            }else{
                ETCDKeyListContentTreeListView(storeObj: storeObj)
            }
            ETCDKeyListContentPageView(storeObj: storeObj)
            ETCDKeyContentMembersListView(storeObj: storeObj)
        }
    }
}
