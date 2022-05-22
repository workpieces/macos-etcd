//
//  HomeConnectView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/12.
//

import SwiftUI
import NavigationStack
import PopupView
import Combine
import FilePicker
import ObjectMapper

struct ETCDTabBarContentView: View {
    
    @EnvironmentObject var storeObj : ItemStore
    
    @State private var isShowToast = false
    
    var body: some View {
        ZStack(alignment: .topLeading,content: {
            VStack {
                ETCDKVTabBarContentHeadView()
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
                .padding(.bottom,-10)
                .offset(y: -20)
                
                HStack(spacing: 20.0){
                    Spacer()
                    Button(action: {
                        NSWorkspace.shared.open(URL.init(string: DefaultOfficialWebsite)!)
                    }, label: {
                        Text("访问官网")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    })
                    Button {
                        NSWorkspace.shared.open(URL.init(string: DefaultFeedback)!)
                    } label: {
                        Text("意见反馈")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.bottom,10)
            }
        })
        .onAppear(perform: {
            storeObj.KVReaload()
        })
        .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 15) {
            TopToastView(title: "The network connection is abnormal, please check the relevant configuration ?")
        }
    }
}



