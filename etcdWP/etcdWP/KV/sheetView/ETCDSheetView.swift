//
//  ETCDSheetView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/25.
//

import SwiftUI

struct ETCDSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var currentModel  : KVOperateModel
    @State var text : String
    var body: some View {
        VStack(){
            Text(currentModel.name).padding(10)
            if currentModel.type == 0 || currentModel.type == 1{
                ETCDTextViewRepresentable(text: $text)
                    .padding(10)
            }else{
                Text("fadfasdfasdkgf")
            }
            HStack(){
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("取消")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("确定")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }.padding(10)
            
        }.frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
    }
}
