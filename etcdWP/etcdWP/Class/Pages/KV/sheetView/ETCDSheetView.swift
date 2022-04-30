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
    @State var leaseText : String = ""
    @State var isShowToast : Bool = false
    @State var isError : Bool = false
    @State var isShowText : String = ""
    @State var isSuccessful : Bool = false
    @State var keyText : String = ""
    @State var valueText : String = ""
    @State var times :Int = 0
    var body: some View {
        VStack(){
            Text(currentModel.name).padding(10)
            if currentModel.type == 0 || currentModel.type == 1{
                if currentModel.type == 1{
                    HStack(){
                        TextField.init("Search", text: $serachText, onEditingChanged: { _ in},onCommit: {
                            
                            
                        }).textFieldStyle(.roundedBorder)
                            .padding(10)
                        TextField.init("替换", text: $replaceText, onEditingChanged: { _ in},onCommit: {
                            
                        }).textFieldStyle(.roundedBorder)
                            .padding(10)
                    }
                    TextEditor(text: $text)
                        .foregroundColor(Color.white)
                        .font(.custom("HelveticaNeue", size: 12))
                        .lineSpacing(1.5)
                        .disableAutocorrection(true)
                        .allowsTightening(true)
                        .padding(.bottom,5)
                        .padding(.top,10)
                        .padding(.trailing,10)
                        .padding(.leading,10)
                        .frame(height: 280)
                }else{
                    VStack(){
                        HStack(){
                            Text("请输入key")
                                .foregroundColor(Color.white)
                                .font(.custom("HelveticaNeue", size: 12))
                                .lineSpacing(1.5)
                                .padding(10)
                            TextField.init("请输入key", text: $keyText, onEditingChanged: { _ in},onCommit: {
                                
                            }).textFieldStyle(.roundedBorder)
                                .padding(10)
                        }
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
                            .padding(.top,10)
                            .padding(.trailing,10)
                            .padding(.leading,10)
                            .frame(height: 280)
                    }

                }
                
                
            }else if(currentModel.type == 2){
                if !self.isShowText.isEmpty {
                    HStack(){
                        Text(self.isShowText)
                            .font(.system(size: 10.0))
                            .foregroundColor(.white)
                        Button {
                            copyToClipBoard(textToCopy: self.isShowText )
                        } label: {
                            Text("粘贴")
                                .font(.system(size: 10.0))
                                .foregroundColor(.yellow)
                        }
                    }
                  
                }
                TextField(currentModel.name, text: $leaseText)
                    .textFieldStyle(.roundedBorder)
                    .padding(10)
                    .textContentType(.oneTimeCode)
                Spacer()
            }else{
                DeletingLeaseListView(items: storeObj.LeaseList()?.datas ?? [])
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
                }
                if self.isSuccessful{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("关闭")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.yellow)
                            .padding(10)
                    }
                }else{
                Button {
                    if self.currentModel.type == 0{
                        if  keyText .isEmpty  || valueText.isEmpty {
                            self.isError.toggle()
                            return
                        }
                        let _ = storeObj.Put(key: keyText, value: valueText)
                        presentationMode.wrappedValue.dismiss()
                    }else if self.currentModel.type == 1{
                        
                        presentationMode.wrappedValue.dismiss()
                    }else if self.currentModel.type == 2{
                        
                        let  numStrin  =  leaseText.trimmingCharacters(in: .decimalDigits)
                        if numStrin.isEmpty {
                            let time = Int(leaseText)
                            if time != times{
                                let  result   =  storeObj.LeaseGrant(ttl:time!)
                                if result?.status != 200 {
                                    self.isError.toggle()
                                    self.isShowToast.toggle()
                                }else{
                                    let ttid  = result?.datas?.first?.ttlid
                                    self.isShowText = String(format:"%ld",ttid!)
                                    self.isSuccessful.toggle()
                                }
                            }

                        }else{
                            self.isShowToast.toggle()
                        }
                        
                        
                    }else if self.currentModel.type == 3{
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                } label: {
                    Text("确定")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.yellow)
                        .padding(10)
                }
                    
                }
            }.padding(.bottom ,10)
            
        }.frame(minWidth: 500, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
         .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
             TopToastView(title:self.isError ? "保存错误":"输入错误请重新输入")
            }
    }
}


