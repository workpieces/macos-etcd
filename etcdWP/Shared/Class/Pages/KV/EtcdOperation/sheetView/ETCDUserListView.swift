//
//  ETCDUserListView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/30.
//

import SwiftUI

struct ETCDUserListView: View {
    @State var items :[KVData]
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    @State var userText: String = ""
    @State var passWordText: String = ""
    @State var user :String = ""
    @State var toastText :String = "操作用户错误"
    @Binding var currentModel  : KVOperateModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(){
            Text(LocalizedStringKey(currentModel.name))
                .padding(.top,10)
                .padding(.trailing,10)
                .padding(.leading,10)
                .padding(.bottom,5)
            HStack(){
                VStack(){
                    HStack(){
                        Text("创建用户")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.trailing,8)
                            .padding(.leading,10)
                        TextField.init("请输入用户", text: $userText)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading,10)
                            .padding(.trailing,5)
                    }
                    HStack(){
                        Text("创建密码")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.trailing,8)
                            .padding(.leading,10)
                        TextField.init("请输入密码", text: $passWordText)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading,10)
                            .padding(.trailing,5)
                    }
                }
                Button {
                    
                    guard !userText.isEmpty else {
                        self.toastText = "用户操作错误"
                        self.isShowToast.toggle()
                        return
                    }
                    
                    guard !passWordText.isEmpty else {
                        self.toastText = "请输入密码"
                        self.isShowToast.toggle()
                        return
                    }
                    self.isShowToast = false
                    
                    if userText != user{
                        let  result   =  storeObj.addUser(user: userText, password: passWordText)
                        if result?.status != 200 {
                            self.toastText = result?.message ?? "用户操作错误"
                            self.isShowToast.toggle()
                        }else{
                            items =  storeObj.UsersList() ?? []
//                            presentationMode.wrappedValue.dismiss()
                            self.isShowToast = false
                        }
                        user = userText
                        
                    }
                    
                } label: {
                    Text("确定")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }.padding(6)
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("关闭")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }.padding(10)
                
            }
            leaseListView
        }
        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
            TopToastView(title:"操作用户错误")
        }
        
    }
}


//方法
extension ETCDUserListView {
    
    func deleFunc(item:KVData) {
        let reuslt = storeObj.removeUser(user: item.user!)
        items = storeObj.UsersList() ?? []
        if reuslt?.status != 200 && reuslt != nil {
            self.isShowToast.toggle()
        }else{
            self.isShowToast = false
        }
    }
}


//列表
extension ETCDUserListView {
    
    private var leaseListView : some View {
        List(items){ item in
            HStack(){
                Text("id：\(item.user ?? "" )")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .opacity(0.75)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("粘贴", action: {
                            copyToClipBoard(textToCopy:item.user!)
                        })
                        Button("移除", action: {
                            deleFunc(item: item)
                        })
                    }))
                Spacer()
                Button {
                    copyToClipBoard(textToCopy:item.user!)
                } label: {
                    Text("粘贴")
                        .font(.system(size: 10.0))
                        .foregroundColor(.white)
                }
                Button {
                    deleFunc(item: item)
                } label: {
                    Text("移除")
                        .font(.system(size: 10.0))
                        .foregroundColor(.white)
                }
            }
        }
        
    }
    
}
