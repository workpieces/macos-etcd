//
//  ETCDUserAssociatedView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/7/10.
//

import SwiftUI

struct ETCDUserAssociatedView: View {
    @State var currentKv :KVData?
    @State var passWordText: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    @State var selectedItems:[KVData] = []
    var body: some View {
        VStack{
            Text(LocalizedStringKey("用户关联角色"))
                .padding(.top,10)
                .padding(.trailing,10)
                .padding(.leading,10)
            HStack{
                Text("当前用户 id:\(currentKv?.user ?? "")")
                    .font(.subheadline)
                    .padding(.top,5)
                    .padding(.trailing,5)
                    .padding(.leading,5)
                    .padding(.bottom,5)
                List(storeObj.RolesList() ?? []){ item in
                    ETCDUserAssociatedItemView(item: item,state: true) { newValue in
                        if newValue {
                            selectedItems.append(item)
                        }else{
                            selectedItems.remove(at:selectedItems.firstIndex(of: item)!)
                        }
                    }
                }
            }
            Spacer()
            HStack{
                Button {
                    
                    print("\(selectedItems)")
                    
                } label: {
                    Text("确定")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }.padding(10)
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("关闭")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }.padding(10)
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
    @State var state:Bool = false
    var callback:(_ newValue: Bool) -> Void
    var body: some View {
        HStack(){
        Text("角色 id：\(item.role ?? "" )")
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.trailing,5)
            .padding(.leading,5)
            .opacity(0.75)
            if (!state){
                Toggle(""  , isOn: $choose)
                    .toggleStyle(.checkbox)
                    .padding(.bottom,3)
                    .onChange(of: choose) { newValue in
                        callback(newValue)
                    }
            }

        }
    }
}
