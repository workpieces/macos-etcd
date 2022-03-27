//
//  KVItem.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/27.
//

import Foundation

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
