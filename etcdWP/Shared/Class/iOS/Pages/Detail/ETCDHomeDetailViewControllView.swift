//
//  ETCDHomeDetailViewControllView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/30.
//

import SwiftUI

struct ETCDHomeDetailViewControllView: View {
    var body: some View {
        GeometryReader { proxy in
            VStack(){
                ETCDHomeDetailNavigationView(title: "ETCD CLUSTER V3")
                ETCDDetialListView().frame(height: proxy.size.height  - proxy.safeAreaInsets.top)
            }
        }
    }
}


struct ETCDHomeDetailViewControllView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDHomeDetailViewControllView()
    }
}
