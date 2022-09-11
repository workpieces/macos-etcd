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
    @State var items:[KVData]?
    public func reloadData(_ item:ItemStore) async{
        self.items = await item.EndpointStatus()
    }
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
                    }.frame(height: UIDevice.isPad() ?  proxy.safeAreaInsets.top + 44 : proxy.safeAreaInsets.top)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            if ((items?.count) != nil) {
                                ForEach(items!.indices,id: \.self){ itemIndex in
                                    ForEach(clusterList,id: \.self){ idx in
                                        let item = items![itemIndex]
                                        VStack{
                                            if itemIndex == 0 {
                                                Text(LocalizedStringKey(idx))
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 14))
                                                    .padding(10)
                                                Divider().frame(height: 0.5)
                                            }
                                            switch idx {
                                            case "id":
                                                Text(item.status?.sid ?? "000000")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .padding(5)
                                                Divider().frame(height: 0.5)
                                            case "endpoint":
                                                Text(item.status?.end_point ?? "http://localhost:2379")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .padding(5)
                                                Divider().frame(height: 0.5)
                                            case "version":
                                                Text(item.status?.etcd_version ?? "3.0.0")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .padding(5)
                                                Divider().frame(height: 0.5)
                                            case "dbSize":
                                                Text(item.status?.db_size ?? "0 B")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .padding(5)
                                                Divider().frame(height: 0.5)
                                            case "dbSizeInUse":
                                                Text(item.status?.db_size_in_use ?? "0 B")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .padding(5)
                                                Divider().frame(height: 0.5)
                                            case "leader":
                                                Text(String(item.status?.is_leader ?? false))
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(item.status?.is_leader ?? false  ? Color.green.opacity(0.9) : Color.red.opacity(0.9))
                                                    .padding(5)
                                                Divider().frame(height: 0.5)
                                                
                                            case "isLearner":
                                                Text(String(item.status?.is_learner ?? false) )
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(item.status?.is_leader ?? false  ? Color.green.opacity(0.9) : Color.red.opacity(0.9))
                                                    .padding(5)
                                                Divider().frame(height: 0.5)
                                                
                                            case "raftTerm":
                                                Text(item.status?.raft_term ?? "0")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .padding(5)
                                                Divider().frame(height: 0.5)
                                            case "raftIndex":
                                                Text( item.status?.raft_index ?? "0")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .padding(5)
                                                Divider().frame(height: 0.5)
                                                
                                            case "raftAppliedIndex":
                                                Text( item.status?.raft_applied_index ?? "0")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .padding(5)
                                                Divider().frame(height: 0.5)
                                            case "errors":
                                                Text( item.status?.errors ?? "none")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .padding(5)
                                                Divider().frame(height: 0.5)
                                            default:
                                                Text("")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .padding(5)
                                            }
                                            
                                        }.padding(.leading,5)
                                        .padding(.trailing,5)
                                    }
                                }
                            }else{
                                ForEach(clusterList,id: \.self){ idx in
                                    VStack{
                                        Text(LocalizedStringKey(idx))
                                            .fontWeight(.semibold)
                                            .font(.system(size: 14))
                                    }.padding(.leading,5)
                                        .padding(.trailing,5)
                                }
                            }
                        }
                        
                    }
                }
                
            }.onAppear{
                Task {
                    await reloadData(storeObj)
                }
                
            }
        }
    }
}
