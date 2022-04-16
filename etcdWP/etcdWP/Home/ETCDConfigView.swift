//
//  ETCDConfigView.swift
//  etcdWP
//
//  Created by taoshumin_vendor on 2022/4/16.
//

import SwiftUI

// 默认用户配置表单
struct UserConfigFormView: View {
    @State private var clientInput = ""
    @State private var usernameInput = ""
    @State private var passwordInput = ""
    var body: some View {
        Section(header: Text("默认用户信息配置")) {
            TextField("客户端名称：", text: $clientInput)
            TextField("用户名：", text: $usernameInput)
            TextField("密码：", text: $passwordInput)
        }
    }
}

// 集群网络表单
struct ClusterNetworkConfigFormView: View {
    @State private var networkInputUnit = 0
    @State private var clusterInputs = ""
    var networks = ["HTTP","HTTPS"]
    var body: some View {
        Section(header: Text("网络节点相关配置")) {
            Picker("网络协议", selection: $networkInputUnit) {
                ForEach(networks.indices) {
                    Text("\(networks[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            TextField("集群节点IP地址", text: $clusterInputs)
        }
    }
}

// 相关超时设置表单
struct ClusterTimeConfigFormView: View {
    @State private var requestTimeoutInput = "3"
    @State private var dailTimeoutInput = "3"
    @State private var dailKeppAliveInput = "3"
    @State private var dailKeppAliveTimeoutInput = "3"
    @State private var autoSyncInterval = "3"
    var body: some View {
        Section(header: Text("超时设置配置（秒）")) {
            TextField("请求超时时长：", text: $requestTimeoutInput)
            TextField("用户名：", text: $requestTimeoutInput)
            TextField("密码：", text: $requestTimeoutInput)
        }
    }
}

struct OtherConfigFormView: View {
    @State private var autoPing = true
    @State private var autoName = true
    @State private var autoSession = true
    @State private var autoConnect = true
    var body: some View {
        Section(header: Text("其他配置")) {
            Toggle("Auto create client name?", isOn: $autoName)
                .toggleStyle(.checkbox)
            Toggle("Reschedule Pings？", isOn: $autoPing)
                .toggleStyle(.checkbox)
            Toggle("Clean Session?", isOn: $autoSession)
                .toggleStyle(.checkbox)
            Toggle("Auto connect on app launch?", isOn: $autoConnect)
                .toggleStyle(.checkbox)
        }
    }
}
struct ETCDConfigView: View {
    @State private var isPopView = false
    var body: some View {
        VStack {
            withDefaultNavagationBack(title: "General Settings", isPop: $isPopView)
                .padding(.vertical,44)
                .padding(.leading ,20)
            
            Form {
                UserConfigFormView()
                ClusterNetworkConfigFormView()
                ClusterTimeConfigFormView()
                OtherConfigFormView()
            }
            .padding(.all,44)
            
            Spacer()
            
        }
    }
}

struct ETCDConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDConfigView()
    }
}
