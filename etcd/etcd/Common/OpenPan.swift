//
//  OpenPan.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/20.
//

import Foundation
import SwiftUI

func showOpenPanel() -> URL? {
    let openPanel = NSOpenPanel()
//    openPanel.allowedContentTypes = ["txt"]
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = false
    openPanel.canCreateDirectories = false;
    openPanel.canChooseFiles = true
    let response = openPanel.runModal()
    return response == .OK ? openPanel.url : nil
}
 
