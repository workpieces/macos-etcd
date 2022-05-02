//
//  NSTextView+.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/28.
//

import Foundation
import Cocoa
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
        }
    }
}
