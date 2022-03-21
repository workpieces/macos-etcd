//
//  EtcdKvView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/13.
//

import SwiftUI
import NavigationStack

struct KVContentView: View {
    @State private var isPopView = false
    var body: some View {
        ZStack(alignment: .topLeading, content: {
            Color
                .clear
                .ignoresSafeArea(.all,edges: .all)
            VStack {
                NavBackView(isPopView: $isPopView,title: "ETCD CLUSTER V3")
                .padding(.vertical,44)
                                
                GeometryReader { geometry in
                    HStack(spacing: 0.0){
                        Color
                            .red
                            .frame(width: geometry.size.width/2, height: geometry.size.height)
                        
                        Color
                            .yellow
                            .frame(width: geometry.size.width/2, height: geometry.size.height)
                    }
                }
            }
        })
    }
}

struct EtcdKvView_Previews: PreviewProvider {
    static var previews: some View {
        KVContentView()
    }
}
