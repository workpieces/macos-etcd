//
//  ETCDTextViewRepresentable.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/25.
//

import SwiftUI
import Cocoa

struct ETCDTextViewRepresentable: NSViewRepresentable {
    
    @Binding var text: String
    
    init(text: Binding<String>) {
        self._text = text
    }
    
    func makeNSView(context: Context) -> NSTextView {
        let textView = getTextView()
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.string = text
    }
    
    func makeCoordinator() -> ETCDTextCoordinator {
        return ETCDTextCoordinator(text: $text)
    }
    
    typealias NSViewType = NSTextView
  
    private func getTextView() -> NSTextView {
        let textView = NSTextView(frame: .zero)
        textView.font = NSFont.systemFont(ofSize: 10)
        textView.textColor = NSColor.white
        textView.backgroundColor = NSColor.clear
        return textView
    }
    
    class ETCDTextCoordinator: NSObject, NSTextViewDelegate
    {
        @Binding var text: String
        init(text: Binding<String>) {
            self._text = text
        }
        
    }

}
