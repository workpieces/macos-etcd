//
//  ETCDPushController.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/7/24.
//

import SwiftUI

struct ETCDPushController: View {
    @EnvironmentObject var homeData: HomeViewModel
    @StateObject private var config = ETCDConfigModel()
    @State private var isToast = false
    var body: some View {
        VStack {            
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
