//
//  HomeClientView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/12.
//

import SwiftUI
import NavigationStack
import PopupView

struct HomeClientCreateView: View {
    @State private var clientName: String = ""
    @State private var endpoints: String = ""
    // auth settings
    @State private var username: String = ""
    @State private var password: String = ""

    // time out setting
    @State private var requestTimeout: Int = 5
    @State private var dailTimeout: Int = 5
    @State private var dialKeepAliveTime: Int = 10
    @State private var dialKeepAliveTimeout: Int = 3
    @State private var autoSyncInterval: Int = 5
    // 跳转等
    @EnvironmentObject var homeData: HomeViewModel
    @State private var isPopView = false
    @State private var showingTopToast = false
    @State var protocalSelection = 0
    // 文件选择
    @State private var cert: String = ""
    @State private var certKey: String = ""
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
                .ignoresSafeArea(.all,edges: .all)
            VStack {
                // nav back view
                withDefaultNavagationBack(title: "Settings", isPop: $isPopView)
                    .padding(.vertical,44)
                    .padding(.leading ,20)
                
                HStack {
                    // left view
                    LeftCreateContentView(clientName: $clientName, username: $username, protocalSelection: $protocalSelection,requestTimeout: $requestTimeout,filename: $cert)
                    Spacer()
                    // middle view
                    MiddleClientCreateView(endpoints: $endpoints, password: $password, protocalSelection: $protocalSelection, dialTimeout: $dailTimeout,filename: $certKey)
                    
                    Spacer()
                    
                    // trail view
                    VStack(spacing: 10.0){
                        EtcdClientTimeTextFiledView(value: $dialKeepAliveTime, title: "Dial Keep Alive Time (Second)", place: "Dial Keep Alive Time")
                        EtcdClientTimeTextFiledView(value: $dialKeepAliveTimeout, title: "Dial Keep Alive Timeout (Second)", place: "Dial Keep Alive Timeout")
                        EtcdClientTimeTextFiledView(value: $autoSyncInterval, title: "Auto Sync Interval (Second)", place: "Auto Sync Interval")
                    }
                }
                .padding()
                .padding(.horizontal,30)
                
                PopView(isActive: $isPopView ) {
                    Button {
                        let ok = Valid()
                        if ok{
                            let data = EtcdClientOption.init(endpoints: [endpoints], serviceName: clientName, username: username, password: password, cert: cert, certKey: certKey, requestTimeout: requestTimeout, dialTimeout: dailTimeout, dialKeepAliveTime: dialKeepAliveTime, dialKeepAliveTimeout: dialKeepAliveTimeout, autoSyncInterval: autoSyncInterval)
                            self.homeData.Append(data: data)
                            self.isPopView.toggle()
                        }else {
                            self.showingTopToast.toggle()
                        }
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
            }
        }
        .padding(.vertical,44)
        .popup(isPresented: $showingTopToast, type: .toast, position: .top, animation: .spring(), autohideIn: 15) {
            TopToastView()
        }
    }
    
    func Valid() -> Bool {
        guard !clientName.isEmpty else {
            return false
        }
        guard !endpoints.isEmpty else {
            return false
        }
        
        guard protocalSelection != 1 else {
            if cert.isEmpty || certKey.isEmpty {
                return false
            }
            if username.isEmpty && password.isEmpty {
                return true
            }
            
            if !username.isEmpty{
                if password.isEmpty {
                    return false
                }
                return true
            }
            return true
        }
        
        if username.isEmpty && password.isEmpty {
            return true
        }
        
        if !username.isEmpty{
            if password.isEmpty {
                return false
            }
            return true
        }
        return true
    }
}

struct HomeClientView_Previews: PreviewProvider {
    static var previews: some View {
        HomeClientCreateView()
    }
}
