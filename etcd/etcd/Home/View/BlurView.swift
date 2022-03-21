//
//  BlurView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI

struct BulrView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        let v = NSVisualEffectView()
        
        v.blendingMode = .behindWindow
        return v
    }
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}
