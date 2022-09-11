//
//  ETCDKeyValueDeleView.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/8/2.
//

import SwiftUI
import SwiftUIRouter
import PopupView
let KeyValueDeleRouterName = "KeyValueDele"
struct ETCDKeyValueDeleView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    @State var keyPrefixText: String = ""
    @State var isSucceful :Bool  = false
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
                        Text(LocalizedStringKey("键值前缀删除"))
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
                    ETCDADBannerTipView()
                        .frame( height:44)
                    HStack(){
                        Text("请输入键值前缀")
                            .foregroundColor(Color.white)
                            .font(.custom("HelveticaNeue", size: 14))
                            .lineSpacing(1.5)
                            .padding(10)
                        TextField.init("请输入前缀key", text: $keyPrefixText).textFieldStyle(.roundedBorder)
                            .padding(.top,10)
                            .padding(.trailing,10)
                            .padding(.leading,10)
                            .padding(.bottom,5)
                    }
                    Button {
                        if  keyPrefixText.isEmpty {
                            self.isShowToast.toggle()
                            return
                        }else{
                            self.isShowToast = false
                        }
                        let result = storeObj.DeletePrefix(key: keyPrefixText)
                        if result?.status  != 200 {
                            self.isSucceful.toggle()
                            self.isShowToast.toggle()
                            return
                        }else{
                            self.isShowToast = false
                            self.isSucceful =  false
                        }
                        navigator.goBack()
                        
                    } label: {
                        Text("确定")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                    ETCDADBannerTipView()
                        .frame( height:44)
                    Spacer()
                }.popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
                    TopToastView(title:self.isSucceful ? "保存失败" : "输入错误，请重新输入")
                }
                
            }
        }
        
    }
}


