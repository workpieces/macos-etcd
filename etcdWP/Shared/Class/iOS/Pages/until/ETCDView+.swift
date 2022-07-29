//
//  ETCDView+.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
extension View {
    func dissmissKeybord() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#endif
