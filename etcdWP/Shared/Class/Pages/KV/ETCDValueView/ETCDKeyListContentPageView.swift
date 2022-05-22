//
//  ETCDKeyListContentPageView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI

struct ETCDKeyListContentPageView: View {
    @EnvironmentObject var storeObj: ItemStore
    var body: some View {
        HStack {
            Spacer()
            Text("当前页:  \(storeObj.realeadData.GetCurrentPage())  ")
                .foregroundColor(.secondary)
                .font(.caption)
            Spacer()
            Button {
                storeObj.Last()
            } label: {
                Text("上一页")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            Spacer()
            Button {
                storeObj.Next()
            } label: {
                Text("下一页")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            Spacer()
            Text("总数:  \(storeObj.realeadData.GetKvCount())  ")
                .foregroundColor(.secondary)
                .font(.caption)
            Spacer()
        }
    }
}
