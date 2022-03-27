//
//  HomeConnectView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/12.
//

import SwiftUI
import NavigationStack

struct ETCDKVContentView: View {
    @StateObject var homeData = HomeViewModel()
    @State private var isPopView = false
    var body: some View {
        ZStack(alignment: .topLeading, content: {
            Color
                .clear
                .ignoresSafeArea(.all,edges: .all)
            VStack {
                NavBackView(isPopView: $isPopView,title: "ETCD CLUSTER V3")
                .padding(.vertical,44)
                .padding(.leading ,20)
                ETCDDetailTabBarView()
            }
        })

    
    }
    
}


struct HomeConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDKVContentView()
    }
}
