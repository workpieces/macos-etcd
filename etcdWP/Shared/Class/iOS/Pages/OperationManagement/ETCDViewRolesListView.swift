//
//  ETCDViewRolesListView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/8/1.
//

import SwiftUI
import SwiftUIRouter
let RolesRouterName = "RolesList"

struct ETCDViewRolesListView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject var storeObj : ItemStore
    init() {
           UITextField.appearance().backgroundColor = .clear
       }
    var body: some View {
        GeometryReader { proxy in
            ZStack{
                VStack{
                    HStack{
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                            .onTapGesture {
                                navigator.goBack()
                            }
                        Spacer()
                        Text(LocalizedStringKey("角色管理"))
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                    }.frame(width:proxy.size.width,height:proxy.safeAreaInsets.top)
                    ETCDViewRolesContentListView(items: storeObj.RolesList() ?? [])
                }
                
            }
        }
        
    }
}

struct ETCDViewRolesContentListView: View {
    @State var items :[KVData]
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    @State var roleText: String = ""
    @State var role :String = ""
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        VStack(){
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
                        let  result   =  storeObj.createRole(roleId: roleText)
                        if result?.status != 200 {
                            self.isShowToast.toggle()
                        }else{
                            items =  storeObj.RolesList() ?? []
//                            presentationMode.wrappedValue.dismiss()
                            self.isShowToast = false
                        }

                    }
                    
                } label: {
                    Text("确定")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }.padding(6)
                Button {
                    let  _ =  navigator.goBack()
                } label: {
                    Text("关闭")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }.padding(10)
            }
            leaseListView
        }
        .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
            TopToastView(title:"操作角色错误")
        }
        
    }
}


//方法
extension ETCDViewRolesContentListView {
    
    func deleFunc(item:KVData) {
        let reuslt = storeObj.removeRole(roleId: item.role!)
        items =   storeObj.RolesList() ?? []
        if reuslt?.status != 200 && reuslt != nil{
            self.isShowToast.toggle()
        }else{
            self.isShowToast = false;
        }
    }
    
    
    
}


//列表
extension ETCDViewRolesContentListView {
    
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
                            deleFunc(item: item)
                        })
                        Button("授权", action: {
                           
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
                    deleFunc(item: item)
                } label: {
                    Text("移除")
                        .font(.system(size: 10.0))
                        .foregroundColor(.white)
                }
                Button {
                    
                } label: {
                    Text("授权")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
            }
        }
        
    }
    
}
