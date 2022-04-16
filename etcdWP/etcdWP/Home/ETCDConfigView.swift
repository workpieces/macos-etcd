//
//  ETCDConfigView.swift
//  etcdWP
//
//  Created by taoshumin_vendor on 2022/4/16.
//

import SwiftUI
import PopupView
import NavigationStack
import FilePicker

// 默认用户配置表单
struct UserConfigFormView: View {
    @State private var clientInput = "etcd-wp-"
    @State private var clientuuidInput =  UUID().uuidString
    @State private var usernameInput = ""
    @State private var passwordInput = ""
    var body: some View {
        Section(header: Text("Default User Information Configuration：")) {
            TextField("Client Name：", text: $clientInput)
            TextField("Client ID：", text: $clientuuidInput)
            TextField("User Name：", text: $usernameInput)
            SecureField("Password：", text: $passwordInput)
        }
    }
}

// 集群网络表单
struct ClusterNetworkConfigFormView: View {
    @State private var networkInputUnit = 0
    @State private var endpointInput = "localhost:2379"
    @State private var certificateFileInput = ""
    @State private var keyFileInput = ""
    var networks = ["HTTP","HTTPS"]
    var body: some View {
        Section(header: Text("Cluster Network Configuration：")) {
            Picker("Network Protocol：", selection: $networkInputUnit) {
                ForEach(networks.indices,id: \.self) {
                    Text("\(networks[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if networkInputUnit == 1 {
                FilePicker(types:[.plainText,.text,.json], allowMultiple: true) { urls in
                    self.certificateFileInput = urls[0].path
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        certificateFileInput.isEmpty ?  Text("Client certificate file:  未选择任何文件"): Text("Client certificate file: \(self.certificateFileInput)")
                    }
                }
                
                FilePicker(types: [.plainText,.text,.json], allowMultiple: true) { urls in
                    self.keyFileInput = urls[0].path
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        keyFileInput.isEmpty ?  Text("Client key file:  未选择任何文件"):    Text("Client key file:  \(self.keyFileInput)")
                    }
                }
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
    @EnvironmentObject var homeData: HomeViewModel
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
            
            PopView(isActive: $isPopView ) {
                Button {
                    
                } label: {
                    Text("Save")
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(width: 120.0,height: 44.0)
                .buttonStyle(PlainButtonStyle())
                .background(Color(hex:"#00FFFF").opacity(0.75))
                .cornerRadius(10.0)
            }
            
            Spacer()
            
        }
    }
}

struct ETCDConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDConfigView()
    }
}
