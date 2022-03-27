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
       ETCDDetailTabBarView()
    }
}

struct EtcdKvView_Previews: PreviewProvider {
    static var previews: some View {
        KVContentView()
    }
}
