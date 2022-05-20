//
//  ETCDMakeOperateKvTextContentView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI

struct ETCDMakeOperateKvTextContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    var body: some View {
        HStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer()
                    Text(storeObj.realeadData.currentKv?.value ?? "")
                        .lineLimit(nil)
                        .foregroundColor(.secondary)
                        .font(.system(size: 12))
                        .lineSpacing(4)
                        .multilineTextAlignment(TextAlignment.leading)
                        .contextMenu(ContextMenu(menuItems: {
                            Button("粘贴", action: {
                                copyToClipBoard(textToCopy: storeObj.realeadData.currentKv?.value ?? "")
                            })
                        }))
                    Spacer()
                }
            }
            Spacer()
            VStack {
                Button {
                    copyToClipBoard(textToCopy: storeObj.realeadData.currentKv?.value ?? "")
                } label: {
                    Text("粘贴")
                        .font(.system(size: 10.0))
                        .foregroundColor(.white)
                }
            }
        }
    }
}
