//
//  HomeConnectView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/12.
//

import SwiftUI
import NavigationStack
import Dispatch

struct ETCDKeyListContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    let DefaultImageName = "key"
    var body: some View {
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
                    Button {
                        storeObj.Reaload()
                    } label: {
                        Text("刷新加载")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    Button {
                        let resp = storeObj.DeleteALL()
                        print(resp as Any)
                        storeObj.Reaload()
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
                Divider()
            })) {
                ForEach(storeObj.GetALL()) { item in
                    HStack {
                        Image(systemName: DefaultImageName)
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
            }
        }
        .listStyle(.sidebar)
    }
}

struct ETCDKVClusterContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    let heads: [String] = ["id","endpoint","version","dbSize","dbSizeInUse","leader","isLearner","raftTerm","raftIndex","raftAppliedIndex","errors"]
    var body: some View {
        List {
            Section(header: HStack(content: {
                ForEach(0..<heads.count) { item in
                    Text(heads[item])
                        .font(.subheadline)
                        .foregroundColor(.orange)
                    Spacer()
                }
            })) {
                ForEach(0..<20) { item in
                    HStack {
                        Group {
                            Text("1")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("2")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        Group{
                            Text("3")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("4")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("5")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        Group {
                            Text("6")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("7")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("8")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        Group{
                            Text("9")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("10")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("11")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
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
    @EnvironmentObject var storeObj : ItemStore
    var body: some View {
        List(storeObj.logs,id:\.self){ item in
            HStack{
                Text(item.message! + " " + item.operate )
            }.padding(5)
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
    }
}



