//
//  ETCDDetialLogView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/31.
//

import SwiftUI

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
    @StateObject private var logs = ETCDLogsObservable()
    var body: some View {
        VStack(alignment: .leading){
            Text("日志")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .opacity(0.75)
                .padding(.leading,20)
                .padding(.top,5)
                .frame(alignment: .leading)
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
    }
}
