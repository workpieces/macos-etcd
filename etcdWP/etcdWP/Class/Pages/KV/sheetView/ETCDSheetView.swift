//
//  ETCDSheetView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/25.
//

import SwiftUI

struct ETCDSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var storeObj : ItemStore
    @Binding var currentModel  : KVOperateModel
    @State var text : String
    @State var serachText : String = ""
    @State var replaceText : String = ""
    var body: some View {
        VStack(){
            Text(currentModel.name).padding(10)
            if currentModel.type == 0 || currentModel.type == 1{
                if currentModel.type == 1{
                    HStack(){
                        TextField.init("Serach", text: $serachText, onEditingChanged: { _ in},onCommit: {
                            
                        }).textFieldStyle(.roundedBorder)
                            .padding(10)
                        TextField.init("替换", text: $replaceText, onEditingChanged: { _ in},onCommit: {
                            
                        }).textFieldStyle(.roundedBorder)
                            .padding(10)
                    }
                }
                ETCDTextViewRepresentable(text: $text)
                    .padding(10)
            }else if(currentModel.type == 2){
                
            }else{
                Text("fdafdasfd")
            }
            HStack(){
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("取消")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.yellow)
                        .padding(10)
                }.padding(30)
                
                Button {
                    if text != storeObj.realeadData.currentKv?.value
                    {
                        storeObj.realeadData.currentKv?.value = text
                      let _ = storeObj.Put(key: (storeObj.realeadData.currentKv?.key)!, value: text)
                    }
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("确定")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.yellow)
                        .padding(10)
                }
            }.padding(.bottom ,10)
            
        }.frame(minWidth: 500, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
    }
}
