//
//  ETCDHomeViewControlleView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/19.
//

import SwiftUI

struct ETCDHomeViewControlleView: View {
    
    @EnvironmentObject var homeData: HomeViewModel
    let closePublisher = NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    NavigationLink(
                        destination:  Text(LocalizedStringKey("创建ETCD客户端"))
                            .withDefaultContentTitle(),
                        label: {
                            HStack {
                                Text(LocalizedStringKey("创建ETCD客户端"))
                                    .withDefaultContentTitle()
                            }
                            .padding(DefaultSpacePadding)
                            .buttonStyle(PlainButtonStyle())
                            .background(Color(hex:"#00FFFF").opacity(0.55))
                            .cornerRadius(8)
                            .clipped()
                        })

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
        }.navigationBarHidden(true)
    }
}

struct ETCDHomeViewControlleView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDHomeViewControlleView()
    }
}
