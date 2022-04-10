//
//  KVStore.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/27.
//

import SwiftUI

import ObjectMapper
struct PairStore:Codable,Mappable {

    var key: String
    var value: String
    var create_revision: Int64?
    var mod_revision: Int64?
    var version: Int64?
    var pairs: [PairStore]?
    
     init?(map: Map){
         self.key = try! map.value("key")
         self.value = try! map.value("value")
         self.create_revision = try? map.value("create_revision")
         self.mod_revision = try? map.value("mod_revision")
         self.version = try? map.value("version")
         self.pairs = try? map.value("pairs")
    }
    mutating func mapping(map: Map) {
        key                 <- map["key"]
        value               <- map["value"]
        create_revision <- map ["create_revision"]
        mod_revision           <- map["mod_revision"]
        version           <- map["version"]
        pairs            <- map["pairs"]
    }
    

}

extension PairStore {
    func toJSON() -> Dictionary<String, String> {
        return [
            "key": self.key,
            "value": self.value,
        ]
    }
}
