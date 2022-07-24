//
//  ETCDHomeViewControlleView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/19.
//

import SwiftUI
import SwiftUIRouter

struct ETCDHomeViewControlleView: View {
    
    @EnvironmentObject var homeData: HomeViewModel
    let closePublisher = NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            ETCDADBannerTipView()
                .padding(.leading,15)
                .padding(.top,20)
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



