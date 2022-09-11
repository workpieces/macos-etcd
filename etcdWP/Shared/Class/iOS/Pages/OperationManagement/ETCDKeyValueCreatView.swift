//
//  ETCDKeyValueActionsListView .swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/8/1.
//

import SwiftUI
import SwiftUIRouter

let KeyValueCreateRouterName = "KeyValueCreat"

struct ETCDKeyValueCreatView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject var storeObj : ItemStore
    @State var keyText:String = ""
    @State var timeText:String = ""
    @State var valueText:String = ""
    @State var isShowToast:Bool = false
    @State var errorString:String = "输入错误，请重新输入"
    init() {
        UITextField.appearance().backgroundColor = .clear
        UITextView.appearance().backgroundColor  = .clear
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
                        Text(LocalizedStringKey("创建键值"))
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
                            self.isShowToast = false
                        }
                        
                        let result = storeObj.PutWithTTL(key: keyText, value: valueText, ttl: timeText.toInt() ?? 0)
                        if result?.status  != 200 {
                            self.errorString = result?.message ?? "保存失败"
                            self.isShowToast.toggle()
                            return
                        }
                        self.isShowToast = false
                        navigator.goBack()
                        
                    } label: {
                        Text("确定")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                    
                }
                
            }
        }.popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
            TopToastView(title:errorString)
        }
    }
}
