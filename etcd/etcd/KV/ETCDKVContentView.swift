//
//  ETCDKVContentView.swift
//  etcd
//
//  Created by FaceBook on 2022/4/3.
//  Copyright © 2022 Workpiece. All rights reserved.
//

import SwiftUI

struct ETCDKVContentView: View {
    @Binding var client:EtcdClientOption
    var body: some View {
        Text("hello world")
//        List(ItemStore.List(c:client.etcdClient).items!, children: \.children) { item in
//           Image(systemName: item.icon)
//           Text(item.name)
//         }
    }
}
