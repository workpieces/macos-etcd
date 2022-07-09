//
//  ETCDUserPasswordView.swift
//  etcdWP (macOS)
//
//  Created by FaceBook on 2022/7/9.
//

import SwiftUI

struct ETCDUserPasswordView: View {
    @State var currentKv :KVData?
    @State var passWordText: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    var body: some View {
        VStack{
            Text(LocalizedStringKey("修改密码"))
                .padding(.top,10)
                .padding(.trailing,10)
                .padding(.leading,10)
            Text("id:\(currentKv?.user ?? "")")
                .padding(.top,5)
                .padding(.trailing,10)
                .padding(.leading,10)
                .padding(.bottom,5)
            TextField.init("请输入密码", text: $passWordText)
                .textFieldStyle(.roundedBorder)
                .padding(.leading,10)
                .padding(.trailing,5)
                .padding(.top,10)
            Spacer()
            HStack{
                Button {
                    
                    guard  !passWordText.isEmpty else{
                        self.isShowToast .toggle()
                        return
                    }
                    let  result   =  storeObj.resetPassword(user: currentKv?.user ?? "", password: passWordText)
                    if result?.status != 200 {
                        self.isShowToast.toggle()
                    }else{
                        self.isShowToast = false
                    }
                    
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
        }.frame(minWidth: 500, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity,alignment: .top)
        .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
                TopToastView(title:"用户操作错误")
            }
    }
    
}

struct ETCDUserPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDUserPasswordView()
    }
}
