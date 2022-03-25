//
//  HomeConnectView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/12.
//

import SwiftUI
import NavigationStack

struct KVView: View {
    @StateObject var homeData = HomeViewModel()
    var body: some View {
            HStack{
                VStack{
                    Text("ETCD CLUSTER")
                        .withDefaultContentTitle()
                        .padding(.top,44.0)
                        .padding(.bottom,22.0)
                    
                    ForEach(etcds,id: \.self) {item in
                        withDefaultTabarButton(
                            imageName: item.image,
                            title: item.title,
                            selectTab: $homeData.selectTab)
                    }
                    Spacer()
                }
                .padding()
                
                
                ZStack(alignment: .top){
                    switch homeData.etcdTab{
                    case "KV": KVContentView()
                    case "Authorize": AuthView()
                    case "Members": MembersView()
                    default: KVContentView() }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(minWidth:720.0,maxWidth: .infinity,maxHeight: .infinity)
            .ignoresSafeArea(.all,edges: .all)
    }
}


struct HomeConnectView_Previews: PreviewProvider {
    static var previews: some View {
        KVView()
    }
}
