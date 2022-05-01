//
//  HomeController.swift
//  samira
//
//  Created by taoshumin_vendor on 2022/3/8.
//

import SwiftUI
import AppKit
import NavigationStack

var screen = NSScreen.main!.visibleFrame

struct ETCDHomeContentView: View {
    @StateObject var homeData = HomeViewModel()
    @ObservedObject var tableData = HomeTabSelectModel()
    
    let closePublisher = NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)
    var body: some View {
        return  NavigationStackView(transitionType: .custom(.opacity)){
            HStack{
                VStack{
                    HStack{
                        Image(MacosLogoName)
                            .withDefaultImage()
                        
                        Text(MacEtcdName)
                            .withDefaultContentTitle(fontSize: 25.0)
                    }
                    .padding(EdgeInsets(top: 44.0, leading: 0.0, bottom: 22.0, trailing: 0.0))
                    
                    ForEach(tabarOption,id: \.self) {item in
                        withDefaultTabarButton(
                            imageName: item.image,
                            title: item.title,
                            selectTab: $tableData.selectTab)
                    }
                    Spacer()
                    Text("Version: \(homeData.getVersion())")
                        .withDefaultContentTitle()
                        .padding(.bottom,DefaultSpacePadding)
                }
                .padding()
                
                ZStack(alignment: .top){
                    switch tableData.selectTab{
                    case "Home": HomeMainView()
                    case "About": AboutView()
                        default: HomeMainView() }
                }
            }
        }
        .environmentObject(homeData)
        .ignoresSafeArea(.all,edges: .all)
        .frame(minWidth: screen.width/1.8, minHeight: screen.height/1.2)
        .navigationViewStyle(.automatic)
        .onReceive(closePublisher) { _ in
            print("Application will Terminate Notification")
            self.homeData.ectdClientList.removeAll()
        }
        .onAppear{
            //优化获取的时机
            self.homeData.WatchListenEtcdClient()
        }
    }
}

struct HomeController_Previews: PreviewProvider {
    static var previews: some View {
        ETCDHomeContentView()
    }
}
