//
//  ETCDOtherConfigFormView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI

struct ETCDOtherConfigFormView: View {
    @StateObject var config : ETCDConfigModel
    var body: some View {
        Section(header: Text("Miscellaneous：")) {
            Toggle("Auto create client name?", isOn: $config.autoName)
            
            Toggle("Reschedule Pings？", isOn: $config.autoPing)
            
            Toggle("Clean Session?", isOn:$config.autoSession)
            
            Toggle("Auto connect on app launch?", isOn: $config.autoConnect)
        }
    }
}

