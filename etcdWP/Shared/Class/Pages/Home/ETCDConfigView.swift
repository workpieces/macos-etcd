//
//  ETCDConfigView.swift
//  etcdWP
//
//  Created by taoshumin_vendor on 2022/4/16.
//

import SwiftUI
import PopupView
import FilePicker
import SwiftUIRouter
import Combine

// 默认用户配置表单
struct UserConfigFormView: View {
    @StateObject var config : ETCDConfigModel
    var body: some View {
        Section(header: Text("Default User Information Configuration：")) {
            TextField("Client Name：", text: $config.clientName)
            TextField("User Name：", text: $config.username)
            SecureField("Password：", text: $config.password)
        }
    }
}

// 集群网络表单
struct ClusterNetworkConfigFormView: View {
    @State private var networkInputUnit = 0
    @State var config : ETCDConfigModel
    var networks = ["HTTP","HTTPS"]
    var body: some View {
        Section(header: Text("Cluster Network Configuration：")) {
            Picker("Network Protocol：", selection: $networkInputUnit) {
                ForEach(networks.indices,id: \.self) {
                    Text("\(networks[$0])")
                }
            }.onChange(of: networkInputUnit, perform: { newValue in
                config.keyFile = ""
                config.certFile = ""
                config.caFile = ""
            })
            .pickerStyle(SegmentedPickerStyle())
            
            if networkInputUnit == 1 {
                FilePicker(types:[.item], allowMultiple: true) { urls in
                    self.config.certFile = urls[0].path
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        self.config.certFile.isEmpty ?  Text("CertFile:  未选择任何文件"): Text("CertFile: \(self.config.certFile)")
                    }
                }
                
                FilePicker(types: [.item], allowMultiple: true) { urls in
                    self.config.keyFile = urls[0].path
                    
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        self.config.keyFile.isEmpty ?  Text("KeyFile:  未选择任何文件"):    Text("KeyFile:  \( self.config.keyFile)")
                    }
                }
                
                FilePicker(types: [.item], allowMultiple: true) { urls in
                    self.config.caFile = urls[0].path
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        self.config.keyFile.isEmpty ?  Text("TrustedCAFile:  未选择任何文件"):    Text("TrustedCAFile:  \( self.config.caFile)")
                    }
                }
            }
            
            TextField("Cluster Endpoint：", text: $config.endpoints[0])
        }
    }
}

// 相关超时设置表单
struct ClusterTimeConfigFormView: View {
    @StateObject var config : ETCDConfigModel
    var body: some View {
        Section(header: Text("Timeout Setting Configuration (seconds)：")) {
            TextField("Request Timeout：",value:$config.requestTimeout, formatter: NumberFormatter())
            TextField("Dial Timeout：",value:$config.dialTimeout, formatter: NumberFormatter())
            TextField("Dial Keep Alive Time：",value:$config.dialKeepAliveTime, formatter: NumberFormatter())
            TextField("Dial Keep Alive Timeout：",value:$config.dialKeepAliveTimeout, formatter: NumberFormatter())
            TextField("Auto Sync Interval：",value:$config.autoSyncInterval, formatter: NumberFormatter())
        }
    }
}

struct OtherConfigFormView: View {
    @StateObject var config : ETCDConfigModel
    var body: some View {
        Section(header: Text("Miscellaneous：")) {
            Toggle("Auto create client name?", isOn: $config.autoName)
#if os(macOS)
                .toggleStyle(.checkbox)
#endif

            Toggle("Reschedule Pings？", isOn: $config.autoPing)
#if os(macOS)
                .toggleStyle(.checkbox)
#endif
            Toggle("Clean Session?", isOn: $config.autoSession)
#if os(macOS)
                .toggleStyle(.checkbox)
#endif
            Toggle("Auto connect on app launch?", isOn: $config.autoConnect)
#if os(macOS)
                .toggleStyle(.checkbox)
#endif
        }
    }
}
struct ETCDConfigView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @StateObject private var config = ETCDConfigModel()
    @EnvironmentObject private var navigator: Navigator
    @State private var isToast = false
    
    var body: some View {
        VStack {
            withDefaultNavagationBack(title: "通用设置")
                .padding(.vertical,30)
                .padding(.leading ,20)
            
            Form {
                UserConfigFormView(config: config)
                ClusterNetworkConfigFormView(config: config)
                ClusterTimeConfigFormView(config: config)
                OtherConfigFormView(config: config)
            }
            .padding(.leading,44)
            .padding(.trailing ,44)
            .padding(.bottom,44.0)
            
            HStack(spacing: 44.0) {
                VStack{
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(width: 120.0,height: 44.0)
                .buttonStyle(PlainButtonStyle())
                .background(Color.red).opacity(0.75)
                .cornerRadius(10.0)
                .onTapGesture {
                    navigator.goBack()
                }
                VStack{
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
                .onTapGesture {
                    let etcdClient  =   EtcdClientOption.init(id: config.id, endpoints: config.endpoints, clientName: config.clientName, username: config.username, password: config.password, certFile: config.certFile, keyFile: config.keyFile, caFile: config.caFile,
                                                              requestTimeout: config.requestTimeout,
                                                              dialTimeout: config.dialTimeout, dialKeepAliveTime: config.dialKeepAliveTime,
                                                              dialKeepAliveTimeout: config.dialKeepAliveTimeout,
                                                              autoSyncInterval: config.autoSyncInterval,
                                                              autoPing: config.autoPing,
                                                              autoName: config.autoName,
                                                              autoSession: config.autoSession,
                                                              autoConnect: config.autoConnect,
                                                              createAt: config.createAt,
                                                              updateAt: config.updateAt,
                                                              status: config.status,
                                                              etcdClient: config.etcdClient,
                                                              checked: config.checked)
                    do{
                        try self.homeData.Register(item: etcdClient)
                        self.homeData.Append(data: etcdClient)
                        navigator.goBack()
                    }catch let error  as  NSError {
                        print("\(error)")
                        self.isToast.toggle()
                    }
                }
            }
            
            Spacer()
        }
        .popup(isPresented: $isToast, type: .toast, position: .top, animation: .spring(), autohideIn: 2) {
            TopToastView(title: "The network connection is abnormal, please check the relevant configuration ?")
        }
    }
}

struct ETCDConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDConfigView()
    }
}
