//
//  KvModel.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/26.
//

import SwiftUI
import MacosEtcd

let etcds:[TabbarOption] = [
    TabbarOption.init(title: "KV", image: "antenna.radiowaves.left.and.right"),
    TabbarOption.init(title: "Authorize", image: "lock.icloud.fill"),
    TabbarOption.init(title: "Members", image: "person.3"),
]


final class ItemStore: ObservableObject {
    @Published private(set) var items: [Item]

    init(items: [Item]) {
        self.items = items
    }
}
