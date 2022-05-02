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
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = true;
    openPanel.canChooseFiles = false
    let response = openPanel.runModal()
    return response == .OK ? openPanel.url : nil
}

func copyToClipBoard(textToCopy: String) {
    let pasteBoard = NSPasteboard.general
    pasteBoard.clearContents()
    pasteBoard.setString(textToCopy, forType: .string)
}

extension String {
    //Converts String to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    //Converts String to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    //Converts String to Bool
    public func toBool() -> Bool? {
        return (self as NSString).boolValue
    }
}

