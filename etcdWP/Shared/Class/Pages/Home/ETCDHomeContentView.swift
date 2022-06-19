//
//  HomeController.swift
//  samira
//
//  Created by taoshumin_vendor on 2022/3/8.
//

import SwiftUI
import AppKit
import NavigationStack
import SwiftUIRouter

var screen = NSScreen.main!.visibleFrame

struct ETCDHomeContentView: View {
    @EnvironmentObject var homeData:HomeViewModel
    var body: some View {
        SwitchRoutes {
            Route(":id/*", validator: findUser) { user in
                ETCDTabBarContentView().environmentObject(ItemStore.init(c:user))
            }
            Route("create") {
                ETCDConfigView().frame(maxWidth: screen.width - DefaultTabbarButtonHeight)
            }
            Route(content: ETCDHomeContentItemView())
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

struct ETCDHomeContentItemView: View {
    @StateObject var  tableData = HomeTabSelectModel()
    var body: some View {
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
                Text("Version: \(tableData.getVersion())")
                    .withDefaultContentTitle()
                    .padding(.bottom,DefaultSpacePadding)
            }
            .padding()
            ZStack(alignment: .top){
                switch tableData.selectTab{
                case "Home": HomeMainView().frame(maxWidth: screen.width - DefaultTabbarButtonHeight)
                case "About": AboutView()
                    default: HomeMainView() }
            }
        }.buttonStyle(.plain)
        .navigationViewStyle(.automatic)
        .environmentObject(tableData)
    }
    
}
