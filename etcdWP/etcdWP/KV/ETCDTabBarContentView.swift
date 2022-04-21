//
//  HomeConnectView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/12.
//

import SwiftUI
import NavigationStack

struct ListModel: Identifiable{
    var id  = UUID()
    var task : String
}

/*
 定义假数据，数据列表
 */
let ListModels = [
    ListModel(task: "namespace/k1/k2"),
    ListModel(task: "pod/k8s/v1"),
    ListModel(task: "deployment/k8s/v1"),
]

struct ETCDKeyListContentView: View {
    let DefaultImageName = "key"
    var body: some View {
        List {
            Section(header:
            VStack(content: {
                HStack{
                    Text("服务地址：127.127.127.127:2379")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#5B9BD4"))
                    Spacer()
                    Text("链接状态: 正常")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(.all,4.0)
                Divider()
            })) {
                ForEach(ListModels) { item in
                    HStack {
                        Image(systemName: DefaultImageName)
                            .foregroundColor(.orange)
                            .font(.system(size: 12.0))
                        Text(item.task)
                            .foregroundColor(.white)
                            .font(.system(size: 11.0,weight: .semibold))
                            .lineSpacing(8.0)
                            .truncationMode(.middle)
                        Spacer()
                        Text("10KB")
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
                            .frame(width: g.size.width/3.2)
                            .border(Color(hex: "#5B9BD4").opacity(0.30), width: 0.5)
                        EmptyView()
                    }
                }
                .padding(.leading,15)
                .padding(.trailing,15)
                .padding(.bottom,20)
                .offset(y: -20)
            }
        })
        .onAppear {
            
        }
    }
}



