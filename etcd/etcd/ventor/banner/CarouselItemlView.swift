//
//  SlideThumbnail.swift
//  TruyenTranh24h
//
//  Created by Huynh Tan Phu on 15/04/2021.
//

import SwiftUI

public struct CarouselItemlView: View {
    @State var item: String
    var height: CGFloat
    var borderRadius: CGFloat
    
    public var body: some View {
        GeometryReader { geo in
            HStack (alignment: .center){
                Image(systemName: item)
                    .scaledToFill()
                    .frame(width: geo.size.width, height: self.height, alignment: .top)
                    .clipped()
                    .background(Color.secondary)
                    .cornerRadius(borderRadius)
                
            }
        }
    }
}
