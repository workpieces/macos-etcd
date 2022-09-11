//
//  ETCDViewUserListView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/8/1.
//

import SwiftUI
import SwiftUIRouter
let UserRouterName = "User"


struct ETCDViewUserListView: View {
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
                        Text(LocalizedStringKey("用户管理"))
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                    }.frame(height: UIDevice.isPad() ?  proxy.safeAreaInsets.top + 44 : proxy.safeAreaInsets.top)
                    ETCDViewUserContentListView(items:storeObj.UsersList() ?? [])
                }
                
            }
        }
        
    }
}


struct ETCDViewUserContentListView: View {
    @State var items :[KVData]
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    @State var userText: String = ""
    @State var passWordText: String = ""
    @State var user :String = ""
    @State var toastText :String = "操作用户错误"
    @State var password:Bool = false
    @State var associated:Bool = false
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        GeometryReader { proxy in
            VStack(){
                HStack(){
                    Text("创建用户")
                        .font(.system(size: 14))
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
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.trailing,8)
                        .padding(.leading,10)
                    TextField.init("请输入密码", text: $passWordText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading,10)
                        .padding(.trailing,5)
                }
                HStack{
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
                                self.isShowToast = false
                            }
                            user = userText
                            
                        }
                        
                    } label: {
                        Text("确定")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }.padding(6)
                    Text("").frame(width: 40)
                    Button {
                        navigator.goBack()
                    } label: {
                        Text("关闭")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }.padding(10)
                }
                ETCDADBannerTipView()
                    .frame(height:44)
                if #available(iOS 15.0, *) {
                    leaseListView
                        .listRowSeparator(.hidden)
                        .sheet(isPresented: $password) {
                            ETCDUserPasswordView(currentKv: self.storeObj.currentKvc)
                        }.sheet(isPresented: $associated) {
                            ETCDUserAssociatedView(currentKv: self.storeObj.currentKvc)
                        }
                } else {
                    leaseListView.sheet(isPresented: $password) {
                        ETCDUserPasswordView(currentKv: self.storeObj.currentKvc)
                    }.sheet(isPresented: $associated) {
                        ETCDUserAssociatedView(currentKv: self.storeObj.currentKvc)
                    }
                }
                if items.count >= 5 {
                    ETCDADBannerTipView()
                        .frame( height:44)
                    Text("").frame(height: 0)
                }
                
            }
            .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
                TopToastView(title:"操作用户错误")
            }
        }
    }
}


//方法
extension ETCDViewUserContentListView {
    
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
extension ETCDViewUserContentListView {
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
                        Button("修改密码", action: {
                            self.storeObj.currentKvc = item
                            self.password.toggle()
                        })
                        Button("关联角色", action: {
                            self.storeObj.currentKvc = item
                            self.associated.toggle()
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
                Button {
                    self.storeObj.currentKvc = item
                    self.password.toggle()
                } label: {
                    Text("修改密码")
                        .font(.system(size: 10.0))
                        .foregroundColor(.white)
                }
                Button {
                    self.storeObj.currentKvc = item
                    self.associated.toggle()
                } label: {
                    Text("关联角色")
                        .font(.system(size: 10.0))
                        .foregroundColor(.white)
                }
            }.listRowBackground(Color.black.opacity(0.2).ignoresSafeArea())
        }.listStyle(.plain)
        .buttonStyle(.plain)
    }
    
}
