//
//  ETCDClusterListView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/8/1.
//

import SwiftUI
import SwiftUIRouter

let ClusterLisRouterName = "/clusterLis"

struct ETCDClusterListItemView {
    var body: some View {
        HStack{
            
        }
    }
}

struct ETCDClusterListView: View {
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
                        Text("clusterList")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                    }.frame(height:proxy.safeAreaInsets.top)
                }
                
            }
        }
        
    }
}

