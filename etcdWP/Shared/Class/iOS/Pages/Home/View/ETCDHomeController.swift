//
//  ETCDHomeController.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI

struct ETCDHomeController: View {
    @EnvironmentObject var homeData: HomeViewModel
    @State private var seletcd = false
    let closePublisher = NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    @State   private  var  choice  = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack{
                VStack{
                    HStack{
                        Image(systemName: "")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                        Spacer()
                        Text("Services")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        HStack{
                            Text("全选")
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            ETCDCheckBoxView(IsChoice: $choice, callback:{ newValue in
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
                            })
                        }.padding(.trailing,10)
                        if homeData.selectedItems.count != 0 {
                            Button {
                                homeData.selectedItems.forEach { item in
                                    let index = self.homeData.ectdClientList.index(of: item)
                                    if index == nil{
                                        return
                                    }
                                    self.homeData.Delete(id:self.homeData.GetUUID(idx:index!))
                                }
                                homeData.selectedItems.removeAll()
                                self.seletcd = false;
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
                    }.frame(height:proxy.safeAreaInsets.top)
                    ScrollView(showsIndicators:false){
                        ETCDADBannerTipView()
                            .frame( height: proxy.safeAreaInsets.top)
                            .padding(.bottom,15)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],spacing: 5){
                            ForEach(Array(self.homeData.ectdClientList.indices),id: \.self) { index in
                                CardItemView(options:homeData.ectdClientList[index],idx: index)
                            }
                        }
                        ETCDADBannerTipView()
                            .frame(height: proxy.safeAreaInsets.top)
                            .padding(.bottom,40)
                    }
                    .padding(.trailing,10)
                    .padding(.leading,10)
                    .padding(.bottom,10)
                }
                
            }.onReceive(timer, perform: {_ in
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

struct SwiftUILearningCapacityHomeController_Previews: PreviewProvider {
    static var previews: some View {
        ETCDHomeController()
    }
}
