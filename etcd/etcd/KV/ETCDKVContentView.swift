//
//  ETCDKVContentView.swift
//  etcd
//
//  Created by FaceBook on 2022/4/3.
//  Copyright © 2022 Workpiece. All rights reserved.
//

import SwiftUI

struct ETCDKVContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    var body: some View {
        List{
            ForEach(storeObj.all(),id: \.key) { item in
                Text(item.key)
            }
        }
    }
}
