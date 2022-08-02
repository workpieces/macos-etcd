//
//  ETCDRootViewControllView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/23.
//

import SwiftUI
import AxisTabView
import SwiftUIRouter

struct ETCDRootViewControllView: View {
    @EnvironmentObject var homeData:HomeViewModel
    var body: some View {
        GeometryReader { _ in
            SwitchRoutes {
                Route(":id/*", validator: findUser) { user in
                    ETCDHomeDetailViewControllView().environmentObject(ItemStore.init(c:user))
                }
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
                Route(content: ETCDRootViewContentView())
            }.navigationTransition()
        }
    }
    
    private func findUser(route: RouteInformation) -> EtcdClientOption? {
        if let parameter = route.parameters["id"],
           let uuid = UUID(uuidString: parameter)
        {
            return homeData.ectdClientList.first { $0.id == uuid }
        }
        return nil
    }
}

struct ETCDRootViewContentView: View {
    var constant = ATConstant(axisMode: .bottom, screen: .init(activeSafeArea: false), tab: .init())
    @State private var selection :Int = 0
    var body: some View {
        GeometryReader { proxy in
            AxisTabView(selection: $selection, constant: constant) { state in
                ETCDTabBarCustomCenterStyle(state, color: Color(hex:"#262626"), radius: 70, depth: 0.85)
            } content: {
                
                ETCDTabBarContenView(constant:constant,name: "Home",  systemName: "house",tag: 0, safeArea: proxy.safeAreaInsets, content: {
                    ETCDHomeController()
                })
                
                ETCDTabBarContenView(constant:constant,  systemName: "plus.circle.fill",tag:  2, safeArea: proxy.safeAreaInsets, content: {
                    
                    ETCDPushController {
                        selection = 0
                    }
                })
                ETCDTabBarContenView(constant:constant,name: "About",  systemName: "info.circle",tag: 1, safeArea: proxy.safeAreaInsets, content: {
                    ETCDiPhoneAboutController()
                })
            }
        }
    }
}

