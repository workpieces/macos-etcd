//
//  ETCDUserAssociatedView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/7/10.
//

import SwiftUI
import Combine

struct ETCDUserAssociatedView: View {
    @State var currentKv :KVData?
    @State var passWordText: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text(LocalizedStringKey("用户关联角色"))
                    .padding(.top,10)
                    .padding(.trailing,10)
                    .padding(.leading,10)
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("关闭")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }.padding(.top,20)
                .padding(.trailing,10)
                .padding(.leading,10)
            }
            Text("当前用户 id:\(currentKv?.user ?? "")")
                .font(.subheadline)
                .padding(.top,5)
                .padding(.trailing,5)
                .padding(.leading,5)
                .padding(.bottom,5)
            List(storeObj.RolesList() ?? []){ item in
                ETCDUserAssociatedItemView(item: item,currentUser: currentKv)
            }
        }.frame(minWidth: 500, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity,alignment: .top)
         .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
                TopToastView(title:"用户操作错误")
            }
    }
}


struct ETCDUserAssociatedItemView: View {
    @State var choose :Bool = false
    @State var item :KVData
    @State var currentUser :KVData?
    @EnvironmentObject var storeObj : ItemStore
    
    private func didModify() {
        
        guard  currentUser != nil else{
            return
        }
        let roles = currentUser!.roles_status?.filter({ roles in
          return  roles.role  == item.role && roles.link == true
        });
        
        print("--------------roles_status:\(currentUser!.roles_status)")
        if (roles != nil ){
            self.choose = true
        }else{
            self.choose = false
        }
    }
    
    var body: some View {
        HStack(){
            Text("角色 id：\(item.role ?? "" )")
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.trailing,5)
                .padding(.leading,5)
                .opacity(0.75)
            Toggle("关联"  , isOn: $choose)
#if os(macOS)
                .toggleStyle(.checkbox)
#endif
                .padding(.bottom,3)
                .onChange(of: choose) { newValue in
                    if newValue {
                        let  _ =  storeObj.grantUserRole(user: currentUser?.user, role: item.role)
                        
                    }else{
                        let  _ =  storeObj.revokesRole(user: currentUser?.user, role: item.role)
                    }
                }.onReceive(Just(choose)) { selection in
                    self.didModify()
                }
        }
    }
}
