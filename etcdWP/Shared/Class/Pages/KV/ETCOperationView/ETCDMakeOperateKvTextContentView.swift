//
//  ETCDMakeOperateKvTextContentView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI
#if os(macOS)
import TextSourceful
#else

#endif
import Combine

struct ETCDMakeOperateKvTextContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    @State var text:String
    var body: some View {
        GeometryReader {  g in
            HStack {
#if os(macOS)
                TextSourceCodeTextEditor(text: $text)
                    .lineLimit(nil)
                    .foregroundColor(.secondary)
                    .font(.system(size: 12))
                    .lineSpacing(4)
                    .padding(.top,10)
                    .padding(.bottom,10)
                    .multilineTextAlignment(TextAlignment.leading)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("粘贴", action: {
                            copyToClipBoard(textToCopy: storeObj.realeadData.currentKv?.value ?? "")
                        })
                    }))
#else
TextEditor
#endif
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
            }.onReceive(Just(text)) { value in
                text =  storeObj.realeadData.currentKv?.value ?? ""
            }
        }

    }
}
