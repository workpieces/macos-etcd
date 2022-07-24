//
//  ETCDADBannerTipView.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/7/24.
//

import SwiftUI

struct ETCDADBannerTipView: View {
    var body: some View {
        GeometryReader(content: { geometry in
        ETCDADBannerView(height:60,width:geometry.size.width - 20,adPosition: .top,adBannerId:adBannderID)
                .frame(width:geometry.size.width-20,height: 60,alignment: .center)
            .cornerRadius(10)
        })
    }
}

struct ETCDADBannerTipView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDADBannerTipView()
    }
}
