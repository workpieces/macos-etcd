//
//  KVStore.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/27.
//

import SwiftUI

import ObjectMapper
struct PairStore:Codable,Mappable,Identifiable,Hashable {
    var id : String?
    var key: String
    var value: String
    var create_revision: Int64?
    var mod_revision: Int64?
    var version: Int64?
    var size: Int64?
    var pairs: [PairStore]?
    
     init?(map: Map){
         self.key = try! map.value("key")
         self.value = try! map.value("value")
         self.create_revision = try? map.value("create_revision")
         self.mod_revision = try? map.value("mod_revision")
         self.version = try? map.value("version")
         self.pairs = try? map.value("pairs")
         self.size = try? map.value("size")
         self.id = UUID().uuidString
    }
    mutating func mapping(map: Map) {
        key                 <- map["key"]
        value               <- map["value"]
        create_revision <- map ["create_revision"]
        mod_revision           <- map["mod_revision"]
        version           <- map["version"]
        pairs            <- map["pairs"]
        size             <- map["size"]
        id = UUID().uuidString
    }
}

struct Cluster: Codable{
    var id :  String
    var name: String
    var status: Bool
    var peer_addr: String
    var client_addr: String
    var is_learner: Bool
}

struct ClusterStatus: Codable{
    var id : String
    var end_point: String
    var etcd_version: String
    var db_size: String
    var is_leader: Bool
    var is_learner: Bool
    var raft_term: String
    var raft_index: String
    var raft_applied_index: String
    var errors: String
}

extension PairStore {
    func toJSON() -> Dictionary<String, String> {
        return [
            "key": self.key,
            "value": self.value,
        ]
    }
}
