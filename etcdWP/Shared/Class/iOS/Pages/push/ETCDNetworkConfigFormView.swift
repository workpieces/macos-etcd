//
//  ETCDNetworkConfigFormView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI
import FilePicker
struct ETCDNetworkConfigFormView: View {
    @State private var networkInputUnit = 0
    @State private var confit:String = "192.168.1.1"
    
    var networks = ["HTTP","HTTPS"]
    var body: some View {
        Section(header: Text("Cluster Network Configuration：").onTapGesture {
            dissmissKeybord()
        }) {
            Picker("Network Protocol：", selection: $networkInputUnit) {
                ForEach(networks.indices,id: \.self) {
                    Text("\(networks[$0])")
                }
            }.onChange(of: networkInputUnit, perform: { newValue in
                
            })
            .pickerStyle(SegmentedPickerStyle())
            if networkInputUnit == 1 {
                FilePicker(types:[.item], allowMultiple: true) { urls in
                    
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text("CertFile:  未选择任何文件")
                    }
                }
                
                FilePicker(types: [.item], allowMultiple: true) { urls in
                    
                    
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        
                    }
                }
                
                FilePicker(types: [.item], allowMultiple: true) { urls in
                    
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text("TrustedCAFile:  未选择任何文件")
                    }
                }
            }
            
            TextField("Cluster Endpoint：", text: $confit)
        }
    }
}
