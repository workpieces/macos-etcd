//
//  KVStore.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/27.
//

import SwiftUI

struct PairStore: Codable {
    var key: String
    var value: String
    var create_revision: Int64
    var mod_revision: Int64
    var version: Int64
    var pairs: [PairStore]?
}

extension PairStore {
    func toJSON() -> Dictionary<String, String> {
        return [
            "key": self.key,
            "value": self.value,
        ]
    }
}
