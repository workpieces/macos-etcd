//
//  HomeMainView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI
import SwiftUIRouter

struct HomeMainView: View {

    var body: some View {
        HomeListView()
    }
}

struct HomeListView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @State private var seletcd = false
    let timer = Timer.publish(every: 8, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            Spacer()
            HStack(){
                Spacer()
                Toggle("全选"  , isOn: $seletcd)
                    .toggleStyle(.checkbox)
                    .padding(.bottom,3)
                    .onChange(of: seletcd) { newValue in
                        homeData.selectedItems.removeAll()
                        if newValue {
                            homeData.ectdClientList.forEach { (vaule) in
                                var tempValue = vaule
                                tempValue.checked = newValue
                                homeData.selectedItems.append(tempValue)
                            }
                        }else{
                            homeData.ectdClientList.forEach { (vaule) in
                                var tempValue = vaule
                                tempValue.checked = newValue
                            }
                        }
                    }
                if homeData.selectedItems.count != 0 {
                    Button {
                        homeData.selectedItems.forEach { item in
                            let index = self.homeData.ectdClientList.index(of: item)
                            self.homeData.Delete(id:self.homeData.GetUUID(idx:index!))
                        }
                        homeData.selectedItems.removeAll()
                        self.seletcd.toggle();
                    } label: {
                        HStack {
                            Text(LocalizedStringKey("全部删除"))
                                .withDefaultContentTitle(fontSize: 10)
                        }
                        .padding(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(Color(hex:"#00FFFF").opacity(0.55))
                    .cornerRadius(5)
                    .clipped()
                }
                withDefaultAddButton(imageName: "plus", title: "创建ETCD客户端")
                    .padding(.top ,40)
                    .padding(.trailing,18)
            }
            HStack {
                Text("Services")
                    .withDefaultContentTitle(fontSize: 30.0)
                Spacer()
            }
            ZStack(alignment: .topLeading){
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: Array(repeating: .init(.flexible(),spacing: GriditemPaddingSpace),count: 3), alignment: .center, spacing: GriditemPaddingSpace) {
                        ForEach(Array(self.homeData.ectdClientList.indices),id: \.self) { index in
                            CardItemView(options: self.homeData.ectdClientList[index],idx: index)
                        }
                    }
                    .padding(GriditemPaddingSpace)
                }
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
            }
        }
    }
}
