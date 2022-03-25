//
//  HomeController.swift
//  samira
//
//  Created by taoshumin_vendor on 2022/3/8.
//

import SwiftUI
import NavigationStack

var screen = NSScreen.main!.visibleFrame

struct HomeView: View {
    @StateObject var homeData = HomeViewModel.init()
    var body: some View {
        return  NavigationStackView(transitionType: .custom(.opacity)){
            HStack{
                VStack{
                    LogoView()
                        .padding(.top,44.0)
                        .padding(.bottom,22.0)
                    ForEach(options,id: \.self) {item in
                        TabButton(image: item.image, title: item.title, selectTab: $homeData.selectTab)
                    }
                    Spacer()
                    Text("Version: 1.0.0")
                        .withDefaultContentTitle()
                        .padding(.bottom,30)
                }
                .padding()
                
                // right view
                ZStack(alignment: .top){
                    switch homeData.selectTab{
                    case "Home": HomeMainView()
                    case "About": AboutView()
                    default: HomeMainView() }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(minWidth:720.0,maxWidth: .infinity,maxHeight: .infinity)
            .background(Color(hex: "#375B7E"))
        }
        .environmentObject(homeData)
        .ignoresSafeArea(.all,edges: .all)
        .frame(minWidth: screen.width/1.7, minHeight: screen.height/1.2)
        .background(Color(hex: "#375B7E"))
        .navigationViewStyle(.automatic)      //  .navigationViewStyle(.stack)
    }
}

struct HomeController_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
