//
//  ETCDKeyPrefixView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/1.
//

import SwiftUI

struct ETCDKeyPrefixView: View {
    
    @Binding var currentModel  : KVOperateModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    @State var keyPrefixText: String = ""
    @State var keyPrefix :String = ""
    @State var isSucceful :Bool  = false
    var body: some View {
        VStack(){
            Text(currentModel.name).padding(10)
            HStack(){
                Text("请输入要删除键值前缀")
                    .foregroundColor(Color.white)
                    .font(.custom("HelveticaNeue", size: 12))
                    .lineSpacing(1.5)
                    .padding(10)
                TextField.init("请输入前缀key", text: $keyPrefixText, onEditingChanged: { _ in},onCommit: {
                    
                }).textFieldStyle(.roundedBorder)
                    .padding(.top,10)
                    .padding(.trailing,10)
                    .padding(.leading,10)
                    .padding(.bottom,5)
            }
            HStack(){
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("取消")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(10)
                }
                Button {
                    if  keyPrefixText.isEmpty {
                        self.isShowToast.toggle()
                        return
                    }
                
                    let result = storeObj.DeletePrefix(key: keyPrefix)
                    if result?.status  != 200 {
                        self.isSucceful.toggle()
                        self.isShowToast.toggle()
                        return
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Text("确定")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(10)
                }
                
            }.padding(.bottom ,10)
            
        }.frame(minWidth: 200, maxWidth: .infinity, minHeight: 150, maxHeight: .infinity)
            .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
                TopToastView(title:self.isSucceful ? "保存失败" : "输入错误，请重新输入")
            }
    }
}

