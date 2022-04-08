//
//  MiddleClientCreateView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/20.
//

import SwiftUI

struct MiddleClientCreateView: View {
    @Binding  var endpoints: String
    @Binding  var password: String
    @Binding var protocalSelection: Int
    @Binding var dialTimeout: Int
    @Binding var filename : String
    let protocal = ["HTTP","HTTPS"]
    var body: some View {
        VStack(spacing: 10.0){
            VStack(alignment: .leading,spacing: 8.0){
                Text("Etcd Version")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .bold().font(.headline)
                HStack {
                    Text("v3.14")
                        .font(.system(size: 12.0, weight: .semibold))
                        .padding(.leading,10.0)
                        .frame(height: 22.0)
                    Spacer()
                }.background(Color.white.cornerRadius(8))
            }
            .frame(maxWidth: 260)
            
            
            VStack(alignment: .leading,spacing: 8.0){
                Text("Endpoints (Require)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .bold().font(.headline)
                
                TextField(
                    "Endpoints",
                    text: $endpoints)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .font(.system(size: 12.0, weight: .semibold))
                .foregroundColor(Color(hex: "#375B7E"))
            }.cornerRadius(8)
            .frame(maxWidth: 260)
            
            if protocalSelection == 1 {
                VStack(alignment: .leading,spacing: 8.0){
                    Text("Client certificate file")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .bold().font(.headline)
                    
                    Button {
                        do {
                            let openURL = showOpenPanel()
                            self.filename = openURL!.path as String
                        } catch  {
                            self.filename = ""
                        }
                    } label: {
                        HStack{
                            Text("选择文件")
                                .lineLimit(1)
                                .font(.system(size: 12.0, weight: .semibold))
                                .foregroundColor(.red)
                                .border(Color.gray.opacity(0.6), width: 1.0)
                                                        
                            Text(filename.isEmpty ? "未选择任何文件" : filename)
                                .font(.system(size: 12.0, weight: .semibold))
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: 260)
            }
            
            VStack(alignment: .leading,spacing: 8.0){
                Text("Password (Option)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .bold().font(.headline)
                
                SecureField(
                    "Password",
                    text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .font(.system(size: 12.0, weight: .semibold))
                .foregroundColor(Color(hex: "#375B7E"))

            }.cornerRadius(8)
            .frame(maxWidth: 260)
            
            
            VStack(alignment: .leading,spacing: 8.0){
                Text("Dial Timeout (Second)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .bold().font(.headline)
                
                TextField(
                    "Dial Timeout",
                    value:$dialTimeout,format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .font(.system(size: 12.0, weight: .semibold))
                .foregroundColor(Color(hex: "#375B7E"))

            }.cornerRadius(8)
            .frame(maxWidth: 260)
        }
    }
}
