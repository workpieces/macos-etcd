//
//  ETCDMenuDrawModel.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/19.
//

import SwiftUI

class ETCDMenuDrawModel: ObservableObject {
    
    @Published var selectedMenu = "Home"
    
    @Published var showDrawer = false
}
