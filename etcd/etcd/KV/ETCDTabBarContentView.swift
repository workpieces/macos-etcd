//
//  HomeConnectView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/12.
//

import SwiftUI
import NavigationStack

struct ETCDTabBarContentView: View {
    @StateObject var homeData = HomeViewModel()
    @State var client:EtcdClientOption
    @State private var isPopView = false
    var body: some View {
        ZStack(alignment: .topLeading, content: {
            Color
                .clear
                .ignoresSafeArea(.all,edges: .all)
            VStack {
                withDefaultNavagationBack(title: "ETCD CLUSTER V3", isPop: $isPopView)
                    .padding(.vertical,44)
                    .padding(.leading ,20)
                ETCDDetailTabBarView(client:client)
            }
        })
    }
}


