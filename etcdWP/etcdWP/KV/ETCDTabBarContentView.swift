//
//  HomeConnectView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/12.
//

import SwiftUI
import NavigationStack
import PopupView

struct ETCDKeyListContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    @State private var showingAlert: Bool = false
    func Reaload() {
        storeObj.Reaload()
    }
    
    func DeleteKey(key: String) {
        storeObj.Delete(key: key)
        Reaload()
    }
    
    func DeleteALL() {
        storeObj.DeleteALL()
        Reaload()
    }
    
    var body: some View {
        VStack {
            List {
                Section(header:VStack(content: {
                    HStack{
                        Text("服务地址：\(storeObj.address)")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#5B9BD4"))
                        Spacer()
                        
                        if storeObj.status {
                            Text("链接状态: 正常")
                                .font(.caption)
                                .foregroundColor(.green)
                        }else{
                            Text("链接状态: 异常")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.all,4.0)
                    
                    HStack {
                        Button {Reaload()} label: {
                            Text("刷新加载")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                        Button {
                            DeleteALL()
                        } label: {
                            Text("清空键值")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                        
                        Spacer()
                        
                        Button {} label: {
                            Text("查询")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                    }
                    Spacer()
                })) {
                    ForEach(storeObj.GetALL()) { item in
                        ZStack {
                            HStack {
                                Image(systemName: DefaultKeyImageName)
                                    .foregroundColor(.orange)
                                    .font(.system(size: 12.0))
                                Text(item.key!)
                                    .foregroundColor(.white)
                                    .font(.system(size: 11.0,weight: .semibold))
                                    .lineSpacing(8.0)
                                    .truncationMode(.middle)
                                Spacer()
                                Text(item.size!)
                                    .foregroundColor(.white)
                                    .font(.system(size: 11.0,weight: .semibold))
                                    .lineSpacing(8.0)
                                    .truncationMode(.middle)
                            }
                        }
                        .onTapGesture(perform: {
                            showingAlert.toggle()
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                
            }
            .listRowInsets(nil)
            .listStyle(.inset)
            
            List {
                Section {
                    ForEach(storeObj.MemberList()) { item in
                        ScrollView(.horizontal,showsIndicators: false) {
                            HStack {
                                Text(item.members?.mid ?? "")
                                Text(item.members?.name ?? "")
                                if ((item.members?.status) != nil) {
                                    Text("True")
                                }else{
                                    Text("False")
                                }
                                Text(item.members?.peer_addr ?? "")
                                Text(item.members?.client_addr ?? "")
                                if ((item.members?.is_learner) != nil) {
                                    Text("True")
                                }else{
                                    Text("False")
                                }
                            }
                        }
                    }
                } header: {
                    VStack {
                        HStack(content: {
                            Text("成员列表: 4")
                                .font(.caption)
                                .foregroundColor(Color(hex: "#5B9BD4"))
                            
                            Spacer()
                            Button {} label: {
                                Text("操作文档介绍")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            }
                        })
                        .padding(.all,4.0)
                    }
                }
                
            }
            .frame(height: 180.0)
        }
    }
}

struct ETCDKVClusterContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    let heads: [String] = ["id","endpoint","version","dbSize","dbSizeInUse","leader","isLearner","raftTerm","raftIndex","raftAppliedIndex","errors"]
    var body: some View {
        List {
            Section(header: HStack(content: {
                ForEach(0..<heads.count, id: \.self) { item in
                    Text(heads[item])
                        .font(.subheadline)
                        .foregroundColor(.orange)
                    Spacer()
                }
            })) {
                ForEach(storeObj.EndpointStatus()) { item in
                    HStack {
                        Group {
                            Text(item.status?.sid ?? "0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(item.status?.end_point ?? "localhost:2379")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        //                        Group{
                        //                            Text(item.status?.etcd_version)
                        //                                .font(.subheadline)
                        //                                .foregroundColor(.gray)
                        //                            Spacer()
                        //                            Text(item.status?.db_size)
                        //                                .font(.subheadline)
                        //                                .foregroundColor(.gray)
                        //                            Spacer()
                        //                            Text(item.status?.db_size_in_use)
                        //                                .font(.subheadline)
                        //                                .foregroundColor(.gray)
                        //                            Spacer()
                        //                        }
                        //                        Group {
                        //                            Text(item.status?.is_leader)
                        //                                .font(.subheadline)
                        //                                .foregroundColor(.gray)
                        //                            Spacer()
                        //                            Text(item.status?.is_learner)
                        //                                .font(.subheadline)
                        //                                .foregroundColor(.white)
                        //                            Spacer()
                        //                            Text(item.status.raft_term)
                        //                                .font(.subheadline)
                        //                                .foregroundColor(.gray)
                        //                            Spacer()
                        //                        }
                        //
                        //                        Group{
                        //                            Text(item.status?.raft_index)
                        //                                .font(.subheadline)
                        //                                .foregroundColor(.gray)
                        //                            Spacer()
                        //                            Text(item.status?.raft_applied_index)
                        //                                .font(.subheadline)
                        //                                .foregroundColor(.gray)
                        //                            Spacer()
                        //                            Text(item.status?.errors)
                        //                                .font(.subheadline)
                        //                                .foregroundColor(.gray)
                        //                            Spacer()
                        //                        }
                    }
                }
            }
        }
        
    }
}

struct ETCDKVOperateContentView: View {
    var body: some View {
        GeometryReader {  g in
            HStack {
                Color.red
                    .frame(width: g.size.width*2/3)
                Color.yellow
                    .frame(width: g.size.width/3)
            }
        }
    }
}

struct ETCDKVLogsContentView: View {
    var body: some View {
        VStack {
            HStack {
                Text("2021-12-13 event: PUT OK ")
                    .foregroundColor(.gray)
                Spacer()
            }
            Spacer()
        }
    }
}

struct ETCDKVGridContentView: View {
    @State var putSelect = false
    var body: some View {
        ZStack(alignment: .topLeading){
            VStack(alignment: .leading,spacing: 10.0){
                Section {
                    ETCDKVClusterContentView()
                        .padding(.leading,10)
                        .padding(.trailing,10)
                        .cornerRadius(10.0)
                        .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                } header: {
                    HStack {
                        Text("集群状态")
                            .foregroundColor(.orange)
                            .padding(.leading,20)
                        Spacer()
                    }
                }
                
                Section {
                    ETCDKVOperateContentView()
                        .padding(.leading,10)
                        .padding(.trailing,10)
                        .cornerRadius(10.0)
                        .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                } header: {
                    HStack {
                        Text("键值操作")
                            .foregroundColor(.orange)
                            .padding(.leading,20)
                        Spacer()
                    }
                }
                
                Section {
                    ETCDKVLogsContentView()
                        .padding(.leading,10)
                        .padding(.trailing,10)
                        .cornerRadius(10.0)
                        .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                } header: {
                    HStack {
                        Text("操作日志")
                            .foregroundColor(.orange)
                            .padding(.leading,20)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ETCDTabBarContentView: View {
    @State private var isPopView = false
    @State private var isShowToast = false
    var body: some View {
        ZStack(alignment: .topLeading, content: {
            VStack {
                withDefaultNavagationBack(title: "ETCD CLUSTER V3", isPop: $isPopView)
                    .padding(.vertical,30)
                    .padding(.leading ,20)
                GeometryReader {  g in
                    HStack(spacing: 10.0) {
                        ETCDKeyListContentView()
                            .frame(width: g.size.width/3.0)
                            .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                        ETCDKVGridContentView()
                            .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                    }
                }
                .padding(.leading,15)
                .padding(.trailing,15)
                .padding(.bottom,20)
                .offset(y: -20)
            }
        })
        .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 15) {
            TopToastView()
        }
    }
}



