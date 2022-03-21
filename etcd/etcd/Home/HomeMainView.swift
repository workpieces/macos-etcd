//
//  HomeMainView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI
import NavigationStack

private let columns: [GridItem] = Array(repeating: .init(.flexible(),spacing: 15.0),count: 3)

struct HomeMainView: View {
    @State var isLinkActive = false
    var body: some View {
        VStack {
            // nav add etcd button
            CreateEtcdButton(isLinkActive: $isLinkActive)
                .padding(.top,25.0)
                .padding(.trailing,25.0)
            
            // nav title
            HStack {
                Text("Services")
                    .fontWeight(.semibold)
                    .font(.system(size: 30.0))
                    .foregroundColor(.white)
                Spacer()
            }
            .offset(x: 15.0, y: -20.0)
            .padding(.bottom,-20)
            
            // bottom view
            BottomMainContentView()
        }
    }
}

struct BottomMainContentView: View {
    @EnvironmentObject var homeData: HomeViewModel
    var body: some View {
        ZStack(alignment: .topLeading){
            ScrollView(.vertical, showsIndicators: true) {
                LazyVGrid(columns: columns, alignment: .center, spacing: 15.0) {
                    PushView(destination: KVView()){
                        ForEach(Array(self.homeData.ectdClientList.indices),id: \.self) { item in
                            CardItemView(options: self.homeData.ectdClientList[item],idx: item)
                        }
                    }
                }
                .padding(15)
            }
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
    }
}
