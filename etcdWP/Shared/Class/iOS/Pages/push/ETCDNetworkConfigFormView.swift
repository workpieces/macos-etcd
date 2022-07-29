//
//  ETCDNetworkConfigFormView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI
import FilePicker
struct ETCDNetworkConfigFormView: View {
    @StateObject var config : ETCDConfigModel
    @State private var networkInputUnit = 0
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
                config.keyFile = ""
                config.certFile = ""
                config.caFile = ""
            })
            .pickerStyle(SegmentedPickerStyle())
            if networkInputUnit == 1 {
                FilePicker(types:[.item], allowMultiple: true) { urls in
                    self.config.certFile = urls[0].path
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        self.config.certFile.isEmpty ?  Text("CertFile:  未选择任何文件"): Text("CertFile: \(self.config.certFile)")
                    }
                }
                
                FilePicker(types: [.item], allowMultiple: true) { urls in
                    self.config.keyFile = urls[0].path
                    
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        self.config.keyFile.isEmpty ?  Text("KeyFile:  未选择任何文件"):    Text("KeyFile:  \( self.config.keyFile)")
                    }
                }
                
                FilePicker(types: [.item], allowMultiple: true) { urls in
                    self.config.caFile = urls[0].path
                } label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        self.config.keyFile.isEmpty ?  Text("TrustedCAFile:  未选择任何文件"):    Text("TrustedCAFile:  \( self.config.caFile)")
                    }
                }
            }
            TextField("Cluster Endpoint：", text: $config.endpoints[0])
        }
    }
}
