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
    @Binding var config : EtcdClientOption
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
    @Binding var config : EtcdClientOption
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
                    self.config.certificate = urls[0].path
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        self.config.certificate.isEmpty ?  Text("Client certificate file:  未选择任何文件"): Text("Client certificate file: \(self.config.certificate)")
                    }
                }
                
                FilePicker(types: [.plainText,.text,.json], allowMultiple: true) { urls in
                    self.config.certKey = urls[0].path
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        self.config.certKey.isEmpty ?  Text("Client key file:  未选择任何文件"):    Text("Client key file:  \( self.config.certKey)")
                    }
                }
            }
            
            TextField("Cluster Endpoint：", text: $config.endpoints[0])
        }
    }
}

// 相关超时设置表单
struct ClusterTimeConfigFormView: View {
    @Binding var config : EtcdClientOption
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
    @Binding var config : EtcdClientOption
    var body: some View {
        Section(header: Text("Miscellaneous：")) {
            Toggle("Auto create client name?", isOn: $config.autoName)
                .toggleStyle(.checkbox)
            Toggle("Reschedule Pings？", isOn: $config.autoPing)
                .toggleStyle(.checkbox)
            Toggle("Clean Session?", isOn: $config.autoSession)
                .toggleStyle(.checkbox)
            Toggle("Auto connect on app launch?", isOn: $config.autoConnect)
                .toggleStyle(.checkbox)
        }
    }
}
struct ETCDConfigView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @State private var config = EtcdClientOption()
    @State private var isPopView = false
    @State private var isToast = false
    
    var body: some View {
        VStack {
            withDefaultNavagationBack(title: "通用设置", isPop: $isPopView)
                .padding(.vertical,30)
                .padding(.leading ,20)
            
            Form {
                UserConfigFormView(config: $config)
                ClusterNetworkConfigFormView(config: $config)
                ClusterTimeConfigFormView(config: $config)
                OtherConfigFormView(config: $config)
            }
            .padding(.leading,44)
            .padding(.trailing ,44)
            .padding(.bottom,44.0)
            
            HStack(spacing: 44.0) {
                PopView {
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
                        self.isPopView.toggle()
                    }
                }
                PopView {
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
                        do{
                            try self.homeData.Register(item: config)
                            self.homeData.Append(data: config)
                            self.isPopView.toggle()
                        }catch {
                            print(error.localizedDescription)
                            self.isToast.toggle()
                        }
                    }
                }
            }
            
            Spacer()
        }
        .popup(isPresented: $isToast, type: .toast, position: .top, animation: .spring(), autohideIn: 3) {
            TopToastView(title: "The network connection is abnormal, please check the relevant configuration ?")
        }
    }
}

struct ETCDConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDConfigView()
    }
}
