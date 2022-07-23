//
//  ETCDHomeViewControlleView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/19.
//

import SwiftUI
import SwiftUIRouter

struct ETCDHomeViewControlleView: View {
    var body: some View {
        SwitchRoutes {
            Route("create/*") {
                ETCDConfigView()
            }
            Route(content: ETCDHomeContentItemView())
        }
    }
}



struct ETCDHomeViewiPhoneContentView: View {
    
    @EnvironmentObject var homeData: HomeViewModel
    let closePublisher = NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()

            }.padding(.trailing,18)
            
            List(self.homeData.ectdClientList.indices,id: \.self) { index in
                CardItemView(options:homeData.ectdClientList[index],idx: index)
            } .onReceive(timer, perform: {_ in
                Task {
                    await homeData.WatchListenEtcdClient()
                }
            }).onDisappear {
                self.timer.upstream.connect().cancel()
            }.onAppear{
                Task {
                    await homeData.WatchListenEtcdClient()
                }
            }.onReceive(closePublisher) { _ in
                self.homeData.ectdClientList.removeAll()
            }
            
        }
    }
}
