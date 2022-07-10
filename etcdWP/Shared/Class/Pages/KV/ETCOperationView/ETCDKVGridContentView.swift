//
//  ETCDKVGridContentView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI

struct ETCDKVGridContentView: View {
    @State var putSelect = false
    var body: some View {
        ZStack(alignment: .topLeading){
            VStack(alignment: .leading,spacing: 10.0){
                Section {
#if os(macOS)
                    ETCDTableViewRepresentableBootcamp()
                        .padding(.leading,10)
                        .padding(.trailing,10)
                        .cornerRadius(10.0)
                        .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
#else
                    ETCDTableViewRepresentableMobileBootcamp()
                        .padding(.leading,10)
                        .padding(.trailing,10)
                        .cornerRadius(10.0)
                        .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
#endif

                } header: {
                    HStack {
                        Text("集群状态")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .padding(.leading,20)
                            .padding(.top,10)
                        Spacer()
                    }
                }
                
                Section {
                    ETCDKVOperateContentView()
                        .padding(.leading,10)
                        .padding(.trailing,10)
                        .cornerRadius(10.0)
                        .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                } header: {
                    HStack {
                        Text("键值操作")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .padding(.leading,20)
                        Spacer()
                    }
                }
                
                Section {
                    ETCDKVLogsContentView()
                        .padding(.leading,10)
                        .padding(.trailing,10)
                        .cornerRadius(10.0)
                        .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                } header: {
                    HStack {
                        Text("操作日志")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .padding(.leading,20)
                        Spacer()
                    }
                }
            }
        }
    }
}


struct ETCDKVGridContentView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDKVGridContentView()
    }
}
