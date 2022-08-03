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

extension CGFloat {
    static func random () -> CGFloat{
        
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
        
    }
}


extension UIColor {
    static func random () -> UIColor{
        return UIColor(red: .random(), green: .random(), blue: .random(),alpha: 1.0)
        
    }
}


#endif
