//
//  ETCDHomeDetailViewControllView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/30.
//

import SwiftUI
import SwiftUIRouter


struct ETCDHomeDetailViewControllView: View {
    @EnvironmentObject var homeData:HomeViewModel
    var body: some View {
        GeometryReader { _ in
            SwitchRoutes {
                Route(UserRouterName){
                    ETCDViewUserListView()
                }
                
                Route(RolesRouterName){
                    ETCDViewRolesListView()
                }
                
                Route(LeaseRouterName){
                    ETCDViewLeaseListView()
                }
                
                Route(KeyValueCreateRouterName){
                    ETCDKeyValueCreatView()
                }
                Route(KeyValueDeleRouterName){
                    ETCDKeyValueDeleView()
                }
                Route(ClusterLisRouterName){
                    ETCDClusterListView()
                }
                Route(content: ETCDHomeDetailContentVieWControllView())
            }.navigationTransition()
        }
    }
}

struct ETCDHomeDetailContentVieWControllView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack(){
                ETCDHomeDetailNavigationView(title: "ETCD CLUSTER V3")
                Divider().frame(height: 0.5)
                ETCDDetialListView()
                    .frame(width: proxy.size.width, height: proxy.size.height - proxy.safeAreaInsets.top)
            }
        }
    }
}
