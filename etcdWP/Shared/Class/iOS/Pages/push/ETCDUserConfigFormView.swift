//
//  ETCDUserConfigFormView.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/7/24.
//

import SwiftUI

struct ETCDUserConfigFormView: View {
    @StateObject var config : ETCDConfigModel
    var body: some View {
        Section(header: Text("Default User Information Configuration：")) {
            TextField("Client Name：", text: $config.clientName)
            TextField("User Name：", text: $config.username)
            SecureField("Password：", text: $config.password)
        }
    }
}
