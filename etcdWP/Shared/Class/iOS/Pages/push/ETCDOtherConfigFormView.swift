//
//  ETCDOtherConfigFormView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI

struct ETCDOtherConfigFormView: View {
    
    @State var autoName:Bool = true
    @State var autoPing:Bool = true
    @State var autoSession:Bool = true
    @State var autoConnect:Bool = true
    
    var body: some View {
        Section(header: Text("Miscellaneous：")) {
            Toggle("Auto create client name?", isOn: $autoName)
            
            Toggle("Reschedule Pings？", isOn: $autoPing)
            
            Toggle("Clean Session?", isOn: $autoSession)
            
            Toggle("Auto connect on app launch?", isOn: $autoConnect)
        }
    }
}

