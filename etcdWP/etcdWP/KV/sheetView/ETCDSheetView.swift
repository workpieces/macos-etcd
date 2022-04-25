//
//  ETCDSheetView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/25.
//

import SwiftUI

struct ETCDSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var text : String
    @Binding var name  : String
    var body: some View {
        VStack(){
            Text(name).padding(10)
            Spacer()
            VStack(){
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                Button("确定") {
                 
                }
                Button("确定") {
                 
                }
                Button("确定") {
                 
                }
                TextField("Password：", text: $text)
            }
        }.frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
    }
}
