//
//  ETCDClusterNetworkConfigFormView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI

struct ETCDClusterNetworkConfigFormView: View {
    
    @StateObject var config : ETCDConfigModel
    
    @State var requestTimeout:Int = 5
    @State var dialTimeout:Int = 5
    @State var dialKeepAliveTime:Int = 5
    @State var autoSyncInterval:Int = 5
    
    var body: some View {
        Section(header: Text("Timeout Setting Configuration (seconds)：")) {
            HStack(){
                Text(LocalizedStringKey("Timeout Setting Configuration (seconds)："))
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .padding(.top,8)
                TextField("Request Timeout：",value:$config.requestTimeout, formatter: NumberFormatter())
                    .font(.system(size: 18))
                    .padding(.top,8)
            }
            
            HStack(){
                Text(LocalizedStringKey("Dial Timeout："))
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .padding(.top,8)
                TextField("Dial Timeout：",value:$config.dialTimeout, formatter: NumberFormatter())
                    .font(.system(size: 18))
                    .padding(.top,8)
                
            }
            HStack(){
                Text(LocalizedStringKey("Dial Keep Alive Time："))
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .padding(.top,8)
                TextField("Dial Keep Alive Time：",value:$config.dialKeepAliveTime, formatter: NumberFormatter())
                    .font(.system(size: 18))
                    .padding(.top,8)
                
            }
            HStack(){
                Text(LocalizedStringKey("Dial Keep Alive Timeout："))
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .padding(.top,8)
                TextField("Dial Keep Alive Timeout：",value:$config.dialKeepAliveTimeout, formatter: NumberFormatter())
                    .font(.system(size: 18))
                    .padding(.top,8)
                
            }
            HStack(){
                Text(LocalizedStringKey("Auto Sync Interval："))
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .padding(.top,8)
                TextField("Auto Sync Interval：",value:$config.autoSyncInterval, formatter: NumberFormatter())
                    .font(.system(size: 18))
                    .padding(.top,8)
            }
            
        }
    }
}
