//
//  ETCDKeyValueActionsView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/30.
//

import SwiftUI

struct ETCDKeyValueActionsView: View {
    
    @State var keyText:String = ""
    @State var timeText:String = ""
    @State var valueText:String = ""
    
    var body: some View {
        VStack(){
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
        }.frame(minWidth: 500, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
            .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
                TopToastView(title:self.isError ? "保存错误":"输入错误请重新输入")
               }
    }
}

struct ETCDKeyValueActionsView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDKeyValueActionsView()
    }
}
