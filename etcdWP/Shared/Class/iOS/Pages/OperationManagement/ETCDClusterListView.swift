//
//  ETCDClusterListView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/8/1.
//

import SwiftUI
import SwiftUIRouter

let ClusterLisRouterName = "clusterLis"

struct ETCDClusterListItemView {
    var body: some View {
        HStack{
            
        }
    }
}

struct ETCDClusterListView: View {
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        GeometryReader { proxy in
            ZStack{
                VStack{
                    HStack{
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                            .onTapGesture {
                                navigator.goBack()
                            }
                        Spacer()
                        Text(LocalizedStringKey("集群状态"))
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                    }.frame(height:proxy.safeAreaInsets.top)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(0 ..< 10){ idx in
                                VStack{
                                    Text("study swiftu\(idx)")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                    Text("study swiftu\(idx)")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }.padding(.leading,10)
                                    .padding(.trailing,10)
                                    .background(Color(.random()))
                                    .cornerRadius(5)
                            }
                        }
                    
                    }
                }
                
            }
        }
        
    }
}

