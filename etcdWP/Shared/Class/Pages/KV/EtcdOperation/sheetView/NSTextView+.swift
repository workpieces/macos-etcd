//
//  NSTextView+.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/28.
//

import Foundation
#if os(macOS)
import Cocoa
import UIKit
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
        }
    }
}
#else

extension UITextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
        }
    }
}

#endif

