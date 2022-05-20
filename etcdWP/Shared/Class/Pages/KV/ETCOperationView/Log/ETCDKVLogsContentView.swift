//
//  ETCDKVLogsContentView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI

struct ETCDKVLogsContentView: View {
    @StateObject private var logs = ETCDLogsObservable()
    var body: some View {
        List(logs.items,id:\.self){ item in
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
            .frame(height: 2.0)
        }
    }
}

struct ETCDKVLogsContentView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDKVLogsContentView()
    }
}
