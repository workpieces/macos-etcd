//
//  ETCDKeyValueActionsView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/30.
//

import SwiftUI

struct ETCDKeyValueActionsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var storeObj : ItemStore
    @Binding var currentModel  : KVOperateModel
    @State var keyText:String = ""
    @State var timeText:String = ""
    @State var valueText:String = ""
    @State var isShowToast:Bool = false
    @State var errorString:String = "输入错误，请重新输入"
    var body: some View {
        VStack(){
            Text(currentModel.name).padding(10)
            HStack(){
                Text("请输入key")
                    .foregroundColor(Color.white)
                    .font(.custom("HelveticaNeue", size: 12))
                    .lineSpacing(1.5)
                    .padding(10)
                TextField.init("请输入key", text: $keyText, onEditingChanged: { _ in},onCommit: {
                    
                }).textFieldStyle(.roundedBorder)
                    .padding(.top,10)
                    .padding(.trailing,10)
                    .padding(.leading,10)
                    .padding(.bottom,5)
            }
            HStack(){
                Text("请输入时间")
                    .foregroundColor(Color.white)
                    .font(.custom("HelveticaNeue", size: 12))
                    .lineSpacing(1.5)
                    .padding(10)
                TextField.init("请输入时间", text: $timeText, onEditingChanged: { _ in},onCommit: {
                    
                }).textFieldStyle(.roundedBorder)
                    .padding(.top,10)
                    .padding(.trailing,10)
                    .padding(.leading,10)
                    .padding(.bottom,5)
            }
            HStack(){
                Text("请输入Value")
                    .foregroundColor(Color.white)
                    .font(.custom("HelveticaNeue", size: 12))
                    .lineSpacing(1.5)
                    .padding(10)
                TextEditor(text: $valueText)
                    .foregroundColor(Color.white)
                    .font(.custom("HelveticaNeue", size: 12))
                    .lineSpacing(1.5)
                    .disableAutocorrection(true)
                    .allowsTightening(true)
                    .padding(.bottom,5)
                    .padding(10)
                    .frame(height: 280)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                    .clipped()
                Spacer().frame(width: 10)
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
                    if  keyText .isEmpty  || valueText.isEmpty {
                        self.errorString = "输入错误，请重新输入"
                        self.isShowToast.toggle()
                        return
                    }
                    
                    if !timeText.isEmpty{
                        let  num  =  timeText.trimmingCharacters(in:.decimalDigits)
                        if !num.isEmpty {
                            self.errorString = "输入时间错误，请重新输入"
                            self.isShowToast.toggle()
                            return
                        }
                    }

                    let result = storeObj.PutWithTTL(key: keyText, value: valueText, ttl: timeText.toInt() ?? 0)
                    if result?.status  != 200 {
                        self.errorString = result?.message ?? "保存失败"
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
            
        }.frame(minWidth: 500, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
            .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
                TopToastView(title:errorString)
            }
    }
}
