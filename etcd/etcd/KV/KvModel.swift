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


enum Item: Hashable, Equatable {
    case file(name: String)
    case directory(name: String, items: [Item])
}

extension Item {
    var name: String {
        switch self {
        case let .file(name), let .directory(name, _):
            return name
        }
    }

    var children: [Item]? {
        guard case let Item.directory(_, items) = self else {
            return nil
        }
        return items
    }
}

final class ItemStore: ObservableObject {
    @Published private(set) var items: [Item]

    init(items: [Item]) {
        self.items = items
    }
}

//extension ItemStore {
//    static func mock(c: EtcdKVClient) -> ItemStore {
//
//        return ItemStore(items: mockItems)
//    }
//
//    // 获取所有etcd的key和value列表
//    func List(c: EtcdKVClient) -> [String] {
//        do {
//            let data = try? c.all()
//            print(data as Any)
//            return []
//        } catch {
//            print(error)
//            return []
//        }
//    }
//}
