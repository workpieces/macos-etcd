//
//  ETCDUserConfigFormView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI

struct ETCDUserConfigFormView: View {
    @State var clientName:String = ""
    @State var username:String = ""
    @State var password:String = ""
    
    var textFieldBorder: some View {
           RoundedRectangle(cornerRadius: 5)
            .stroke(Color.white, lineWidth: 0.5)
       }
    var body: some View {
        Section(header: Text("Default User Information Configuration：")) {
            HStack(){
                Text(LocalizedStringKey("Client Name："))
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .padding(.top,8)
                TextField("Client Name：", text:$clientName)
                    .font(.system(size: 18))
                    .padding(.top,8)
            }
            
            HStack(){
                Text(LocalizedStringKey("User Name："))
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .padding(.top,8)
                TextField("User Name：", text:$username)
                    .font(.system(size: 18))
                    .padding(.top,8)
            }
            HStack(){
                Text(LocalizedStringKey("Password："))
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .padding(.top,8)
                SecureField("Password：", text:$password)
                    .font(.system(size: 18))
                    .padding(.top,8)
            }
        }
        
    }
}
