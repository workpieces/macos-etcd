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
                ScrollView{
                    ETCDetialContentView()
                        .frame(height: proxy.size.height * 0.7)
                    ETCDDetialLogView()
                        .frame(height:proxy.size.height * 0.4)
                }
            }.onTapGesture {
                dissmissKeybord()
            }.ignoresSafeArea()
              .onAppear(perform: {
                    UITableView.appearance().separatorStyle = .none
                    Task{
                        await  storeObj.KVReaload(false)
                    }
                })
        }
        
    }
}
