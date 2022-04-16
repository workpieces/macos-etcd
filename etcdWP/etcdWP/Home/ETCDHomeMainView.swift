//
//  HomeMainView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI
import NavigationStack

struct HomeMainView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @State var isLinkActive = false
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            withDefaultAddButton(imageName: "plus", title: "Create Etcd Client", link: $isLinkActive)
                .padding(.top ,40)
                .padding(.trailing,18)
            HStack {
                Text("Services")
                    .withDefaultContentTitle(fontSize: 30.0)
                Spacer()
            }
            
            ZStack(alignment: .topLeading){
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: Array(repeating: .init(.flexible(),spacing: GriditemPaddingSpace),count: 3), alignment: .center, spacing: GriditemPaddingSpace) {
                        ForEach(Array(self.homeData.ectdClientList.indices),id: \.self) { item in
                            PushView(destination: ETCDTabBarContentView()
                                .environmentObject(ItemStore.init(
                                    c: self.homeData.ectdClientList[item].etcdClient,address: self.homeData.ectdClientList[item].endpoints.first!))){
                                CardItemView(options: self.homeData.ectdClientList[item],idx: item)
                            }
                        }
                       
                    }
                    .padding(GriditemPaddingSpace)
                }
                .onReceive(timer, perform: {
                    _ in
                    homeData.WatchListenEtcdClient()
                    print("------")
                }).onDisappear {
                    self.timer.upstream.connect().cancel()
                }
            }
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
    }
}
