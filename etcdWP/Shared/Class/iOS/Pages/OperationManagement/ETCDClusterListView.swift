//
//  ETCDClusterListView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/8/1.
//

import SwiftUI
import SwiftUIRouter


fileprivate let clusterList: [String] = ["id","endpoint","version","dbSize","dbSizeInUse","leader","isLearner","raftTerm","raftIndex","raftAppliedIndex","errors"]

let ClusterLisRouterName = "clusterLis"

struct ETCDClusterListItemView {
    var body: some View {
        HStack{
            
        }
    }
}

struct ETCDClusterListView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject var storeObj : ItemStore
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
                            ForEach(clusterList,id: \.self){ idx in
                                VStack{
                                    Text(LocalizedStringKey(idx))
                                        .fontWeight(.semibold)
                                        .font(.system(size: 14))
                                    if ((storeObj.EndpointStatus().count) != nil) {
                                        ForEach(storeObj.EndpointStatus()){ item in
                                            VStack{
                                                switch idx {
                                                case "id":
                                                    Text(item.status?.sid ?? "000000")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                case "endpoint":
                                                    Text(item.status?.end_point ?? "http://localhost:2379")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                case "version":
                                                    Text(item.status?.etcd_version ?? "3.0.0")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                case "dbSize":
                                                    Text(item.status?.db_size ?? "0 B")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                case "dbSizeInUse":
                                                    Text(item.status?.db_size_in_use ?? "0 B")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                case "leader":
                                                    Text(String(item.status?.is_leader) ?? "false")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(item.status?.is_leader ?? false  ? Color.green.opacity(0.9) : Color.red.opacity(0.9))
                                                    
                                                case "isLearner":
                                                    Text(String(item.status?.is_learner) ?? "false")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(item.status?.is_leader ?? false  ? Color.green.opacity(0.9) : Color.red.opacity(0.9))
                                                    
                                                case "raftTerm":
                                                    Text(item.status?.raft_term ?? "0")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                case "raftIndex":
                                                    Text( item.status?.raft_index ?? "0")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                    
                                                case "raftAppliedIndex":
                                                    Text( item.status?.raft_applied_index ?? "0")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                case "errors":
                                                    Text( item.status?.errors ?? "none")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                default:
                                                    Text("")
                                                        .font(.subheadline)
                                                        .fontWeight(.semibold)
                                                }
                                            }
                                            
                                        }
                                    }else{
                                        Text("")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                    }
                                    
                                }.padding(.leading,5)
                                    .padding(.trailing,5)
                            }
                        }
                        
                    }
                }
                
            }
        }
    }
}
