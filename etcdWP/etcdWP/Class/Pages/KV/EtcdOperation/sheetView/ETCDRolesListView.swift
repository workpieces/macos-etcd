//
//  ETCDRolesListView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/30.
//

import SwiftUI

struct ETCDRolesListView: View {
    @State var items :[KVData]
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    @State var isSucceFul: Bool = false
    @State var roleText: String = ""
    @State var role :String = ""
    @Binding var currentModel  : KVOperateModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(){
            Text(currentModel.name)
                .padding(.top,10)
                .padding(.trailing,10)
                .padding(.leading,10)
                .padding(.bottom,5)
            HStack(){
                Text("创建角色")
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.trailing,8)
                    .padding(.leading,10)
                TextField.init("请输入角色", text: $roleText)
                    .textFieldStyle(.roundedBorder)
                    .padding(10)
                Button {
                    
                    guard !roleText.isEmpty else{
                        return
                    }
                    if roleText != role{
                        role = roleText
//                        let  result   =  storeObj.createRole(roleId: roleText)
//                        if result?.status != 200 {
//                            self.isSucceFul.toggle()
//                            self.isShowToast.toggle()
//                        }else{
//                            items =  storeObj.RolesList()
//                        }
                        presentationMode.wrappedValue.dismiss()
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
            TopToastView(title:"操作角色错误")
           }

    }
}


//方法
extension ETCDRolesListView {
    
//     func deleFunc(item:ETCDRoleDetailModel) {
//         let reuslt = storeObj.removeRole(roleId: item.role!)
//        if reuslt?.status != 200{
//            self.isShowToast.toggle()
//        }else{
//            self.isSucceFul .toggle()
//            self.isShowToast.toggle()
//        }
//    }
    
 
    
}


//列表
extension ETCDRolesListView {
    
    private var leaseListView : some View {
        List(items){ item in
            HStack(){
                Text("角色：\(item.role!)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .opacity(0.75)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("粘贴", action: {
                            copyToClipBoard(textToCopy:item.role!)
                        })
                        Button("移除", action: {
//                            deleFunc(item: item)
                        })
                    }))
                Spacer()
                Button {
                    copyToClipBoard(textToCopy:item.role!)
                } label: {
                    Text("粘贴")
                        .font(.system(size: 10.0))
                        .foregroundColor(.white)
                }
                Button {
//                    deleFunc(item: item)
                } label: {
                    Text("移除")
                        .font(.system(size: 10.0))
                        .foregroundColor(.white)
                }
            }
        }
        
    }
    
}
