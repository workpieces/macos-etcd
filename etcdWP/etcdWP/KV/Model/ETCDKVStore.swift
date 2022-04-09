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
    var create_revision: String
    var mod_revision: String
    var version: String
    var size: Int
    var pairs: [PairStore]? = nil
}

extension PairStore {
    func toJSON() -> Dictionary<String, String> {
        return [
            "key": self.key,
            "value": self.value
        ]
    }
}
