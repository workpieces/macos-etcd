//
//  ETCDDetialLogView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/31.
//

import SwiftUI

struct ETCDDetialLogView: View {
    @StateObject private var logs = ETCDLogsObservable()
    var body: some View {
        List(logs.items.reversed(),id:\.self){ item in
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
            }
        }
    }
}

struct ETCDDetialLogView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDDetialLogView()
    }
}
