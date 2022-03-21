//
//  LeftCreateContentView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/20.
//

import SwiftUI

struct EtcdClientTimeTextFiledView: View {
    @Binding var value: Int
    var title: String
    var place: String
    var body: some View {
        VStack(alignment: .leading,spacing: 8.0){
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .bold().font(.headline)
            
            TextField(
                place,
                value:$value,format: .number)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .disableAutocorrection(true)
            .border(Color.gray)
            .font(.system(size: 12.0, weight: .semibold))
            .foregroundColor(Color(hex: "#375B7E"))
            .textFieldStyle(.roundedBorder)
        }
        .frame(maxWidth: 260)
    }
}


struct LeftCreateContentView: View {
    @Binding  var clientName: String
    @Binding  var username: String
    @Binding var protocalSelection: Int
    @Binding var requestTimeout: Int
    @Binding var filename : String
    let protocal = ["HTTP","HTTPS"]
    var body: some View {
        VStack(spacing: 10.0){
            VStack(alignment: .leading,spacing: 8.0){
                Text("Client Name (Require)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .bold().font(.headline)
                
                TextField(
                    "Client Name",
                    text: $clientName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .border(Color.gray)
                .font(.system(size: 12.0, weight: .semibold))
                .foregroundColor(Color(hex: "#375B7E"))
                .textFieldStyle(.roundedBorder)
            }
            .frame(maxWidth: 260)
            
            
            VStack(alignment: .leading,spacing: 8.0){
                Text("Protocol")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .bold().font(.headline)
                
                Picker("", selection: $protocalSelection) {
                    ForEach(protocal.indices , id: \.self){ i in
                        Text(self.protocal[i])
                            .font(.system(size: 12.0, weight: .semibold))
                    }
                }
                .frame(height: 22.0)
                .offset(x: -4.0)
                .pickerStyle(.menu)
            }
            .frame(maxWidth: 260)
            
            if protocalSelection == 1 {
                VStack(alignment: .leading,spacing: 8.0){
                    Text("CA file")
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
                Text("Username (Option)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .bold().font(.headline)
                
                TextField(
                    "Username",
                    text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .border(Color.gray)
                .font(.system(size: 12.0, weight: .semibold))
                .foregroundColor(Color(hex: "#375B7E"))
                .textFieldStyle(.roundedBorder)
            }
            .frame(maxWidth: 260)
            
            
            VStack(alignment: .leading,spacing: 8.0){
                Text("Request Timeout (Second)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .bold().font(.headline)
                
                TextField(
                    "Request Timeout",
                    value:$requestTimeout,format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .border(Color.gray)
                .font(.system(size: 12.0, weight: .semibold))
                .foregroundColor(Color(hex: "#375B7E"))
                .textFieldStyle(.roundedBorder)
            }
            .frame(maxWidth: 260)
        }
    }
}
