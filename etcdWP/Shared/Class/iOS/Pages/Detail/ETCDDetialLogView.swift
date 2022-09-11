//
//  ETCDDetialLogView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/31.
//

import SwiftUI
import PopupView
struct ETCDDetialLogViewItemiew: View {
   @State var  item:KVOperateLog;
    var body: some View {
        HStack{
            Text(item.formatTime())
                .font(.subheadline)
                .foregroundColor(.green)
                .opacity(0.75)
            Text(item.formatStatus())
                .font(.subheadline)
                .foregroundColor(item.status == 200 ? .yellow: .red)
                .opacity(0.75)
            Text(item.formatOperate())
                .font(.subheadline)
                .foregroundColor(Color(hex:"#00FFFF"))
                .opacity(0.75)
            Text(item.formatMessage())
                .font(.subheadline)
                .foregroundColor(item.status == 200 ? .secondary : .red)
                .lineLimit(1)
                .opacity(item.status == 200 ? 0.75 : 1.0)
            Spacer()
        }.listRowBackground(Color.black.opacity(0.2).ignoresSafeArea())
    }
}


struct ETCDDetialLogView: View {
    @State var isEnble:Bool = false
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast:Bool = false
    @StateObject private var logs = ETCDLogsObservable()
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Log")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .opacity(0.75)
                    .padding(.leading,20)
                    .padding(.top,5)
                    .frame(alignment: .leading)
                Spacer()
                Text(LocalizedStringKey("开启认证"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .opacity(0.75)
                    .padding(.trailing,5)
                    .padding(.leading,8)
                ETCDCheckBoxView(IsChoice: $isEnble) {  newValue in
                    let keyValue =  storeObj.authEnable(enble: !newValue)
                    if keyValue?.status != 200{
                        self.isShowToast.toggle()
                        isEnble = false
                    }
                }.padding(.trailing,10)
                
            }
            Divider().frame(height:0.5)
            List(logs.items.reversed(),id:\.self){ item in
                if #available(iOS 15.0, *) {
                    ETCDDetialLogViewItemiew(item: item)
                        .listRowSeparator(.hidden)
                } else {
                    ETCDDetialLogViewItemiew(item: item)
                }
            }.listStyle(.plain)
        }
        .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
            TopToastView(title:"开启认证失败")
        }
    }
}
