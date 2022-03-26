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
                            selectTab: $homeData.selectTab)
                    }
                    Spacer()
                    Text(MacosEtcdVersion)
                        .withDefaultContentTitle()
                        .padding(.bottom,30)
                }
                .padding()
                
                ZStack(alignment: .top){
                    switch homeData.selectTab{
                    case "Home": HomeMainView()
                    case "About": AboutView()
                        default: HomeMainView() }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(minWidth:720.0,maxWidth: .infinity,maxHeight: .infinity)
        }
        .environmentObject(homeData)
        .ignoresSafeArea(.all,edges: .all)
        .frame(minWidth: screen.width/1.7, minHeight: screen.height/1.2)
        .background(Color(hex: "#375B7E"))
        .navigationViewStyle(.automatic)
    }
}

struct HomeController_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
