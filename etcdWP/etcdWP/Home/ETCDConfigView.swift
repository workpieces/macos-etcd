//
//  ETCDConfigView.swift
//  etcdWP
//
//  Created by taoshumin_vendor on 2022/4/16.
//

import SwiftUI

// 默认用户配置表单
struct UserConfigFormView: View {
    @State private var clientInput = "etcd-name"
    @State private var usernameInput = ""
    @State private var passwordInput = ""
    var body: some View {
        Section(header: Text("Default User Information Configuration：")) {
            TextField("Client Name：", text: $clientInput)
            TextField("User Name：", text: $usernameInput)
            SecureField("Password：", text: $passwordInput)
        }
    }
}

// 集群网络表单
struct ClusterNetworkConfigFormView: View {
    @State private var networkInputUnit = 0
    @State private var endpointInput = "localhost:2379"
    var networks = ["HTTP","HTTPS"]
    var body: some View {
        Section(header: Text("Cluster Network Configuration：")) {
            Picker("Network Protocol：", selection: $networkInputUnit) {
                ForEach(networks.indices) {
                    Text("\(networks[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if networkInputUnit == 1 {
                TextField("Client certificate file：", text: $endpointInput)
                TextField("Client key file：", text: $endpointInput)
            }
            
            TextField("Cluster Endpoint：", text: $endpointInput)
        }
    }
}

// 相关超时设置表单
struct ClusterTimeConfigFormView: View {
    @State private var requestTimeoutInput = 5
    @State private var dailTimeoutInput = 5
    @State private var dailKeppAliveInput = 10
    @State private var dailKeppAliveTimeoutInput = 3
    @State private var autoSyncInterval = 5
    var body: some View {
        Section(header: Text("Timeout Setting Configuration (seconds)：")) {
            TextField("Request Timeout：",value:$requestTimeoutInput, formatter: NumberFormatter())
            TextField("Dial Timeout：",value:$dailTimeoutInput, formatter: NumberFormatter())
            TextField("Dial Keep Alive Time：",value:$dailKeppAliveInput, formatter: NumberFormatter())
            TextField("Dial Keep Alive Timeout：",value:$dailKeppAliveTimeoutInput, formatter: NumberFormatter())
            TextField("Auto Sync Interval：",value:$autoSyncInterval, formatter: NumberFormatter())
        }
    }
}

struct OtherConfigFormView: View {
    @State private var autoPing = true
    @State private var autoName = true
    @State private var autoSession = true
    @State private var autoConnect = true
    var body: some View {
        Section(header: Text("Miscellaneous：")) {
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
