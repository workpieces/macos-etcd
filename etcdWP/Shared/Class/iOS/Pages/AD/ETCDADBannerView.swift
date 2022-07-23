//
//  ETCDADBannerView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/23.
//

import SwiftUI
import GoogleMobileAds

struct ETCDADBannerView:UIViewRepresentable {
    
    private func getTextField() -> GADBannerView {
        let textfield = GADBannerView(frame: .zero)
        let placeholder =  NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor : placeholderColor
            ])
        textfield.attributedPlaceholder = placeholder
        return textfield
    }
    
    
    func makeUIView(context: Context) -> GADBannerView {
        
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        
    }
    
    
    typealias UIViewType = GADBannerView
    
    
    
    
}
