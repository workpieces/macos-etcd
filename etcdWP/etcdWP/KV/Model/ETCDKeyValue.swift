//
//  ETCDKeyValue.swift
//  etcdWP
//
//  Created by taoshumin_vendor on 2022/4/22.
//

import SwiftUI
import Foundation

struct ETCDKeyValue: Codable {
    let datas: [KVData]?
    // status is response status
    // 200 is success,otherwise fail
    let status: Int?
    // message is response data message.
    // ok or error message
    let message: String?
    // operate
    let operate: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case operate
        case datas
    }
}

struct KVData: Codable, Identifiable {
    var id = UUID()
    
    // ttlid is lease id.
    let ttlid : Int64?
    // lease ttl default time to expire.
    let ttl : Int64?
    // GrantedTTL is the initial granted time in seconds upon lease creation/renewal.
    let granted_ttl: Int64?
    // key is the key in bytes. An empty key is not allowed.
    let key : String?
    // create_revision is the revision of last creation on this key.
    let create_revision : Int64?
    // mod_revision is the revision of last modification on this key.
    let mod_revision : Int64?
    // version is the version of the key. A deletion resets
    // the version to zero and any modification of the key
    // increases its version.
    let version : Int64?
    // value is the value held by the key, in bytes.
    let value : String?
    // lease is the ID of the lease that attached to key.
    // When the attached lease expires, the key will be deleted.
    // If lease is 0, then no lease is attached to the key.
    let lease: Int64?
    // size is current key value size
    let size: String?
    // etcd endpoint status
    let status: KVStatus?
    
    enum CodingKeys: String, CodingKey {
        case ttlid
        case ttl
        case granted_ttl
        case key
        case create_revision
        case mod_revision
        case version
        case value
        case lease
        case size
        case status
    }
}

struct KVStatus: Codable, Identifiable {
    var id = UUID()
    
    let sid : String?
    let end_point : String?
    let etcd_version :String?
    let db_size : String?
    let db_size_in_use : String?
    let is_leader : Bool?
    let is_learner : Bool?
    let raft_term : String?
    let raft_index : String?
    let raft_applied_index : String?
    let errors : String?
    
    enum CodingKeys: String, CodingKey {
        case sid
        case end_point
        case etcd_version
        case db_size
        case db_size_in_use
        case is_leader
        case is_learner
        case raft_term
        case raft_index
        case raft_applied_index
        case errors
    }
}

struct KVOperateLog: Identifiable {
    var id  = UUID()
    var time: Date = Date()
    var status: Int?
    var message: String?
    var operate: String
    init(status: Int,message: String,operate: String) {
        self.status = status
        self.message = message
        self.operate = operate
    }
}