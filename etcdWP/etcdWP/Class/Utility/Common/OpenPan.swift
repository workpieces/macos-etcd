//
//  OpenPan.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/20.
//

import Foundation
import SwiftUI

// 打开文件目录
func showOpenPanel() -> URL? {
    let openPanel = NSOpenPanel()
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = false
    openPanel.canCreateDirectories = false;
    openPanel.canChooseFiles = true
    let response = openPanel.runModal()
    return response == .OK ? openPanel.url : nil
}

func copyToClipBoard(textToCopy: String) {
    let pasteBoard = NSPasteboard.general
    pasteBoard.clearContents()
    pasteBoard.setString(textToCopy, forType: .string)
}

 
