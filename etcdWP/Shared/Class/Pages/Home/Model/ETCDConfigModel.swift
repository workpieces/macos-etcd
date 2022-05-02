//
//  EtcdViewModel.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/13.
//

import Foundation
import MacosEtcd

struct EtcdClientOption: Identifiable,Codable {
    var id = UUID()
    var endpoints: [String] = ["localhost:2379"]
    var clientName: String = "etcd-wp-\(UUID().uuidString.suffix(6))"
    var username: String = ""
    var password: String = ""
    var certificate: String = ""
    var certKey: String = ""
    var requestTimeout: Int = 5
    var dialTimeout: Int = 5
    var dialKeepAliveTime: Int = 10
    var dialKeepAliveTimeout: Int = 3
    var autoSyncInterval:Int = 5
    var autoPing: Bool = true
    var autoName: Bool = true
    var autoSession: Bool = true
    var autoConnect: Bool = true
    var createAt: Date = Date()
    var updateAt: Date = Date()
    var status: Bool = false
    var etcdClient: EtcdKVClient?
    
    enum CodingKeys: String, CodingKey {
        case endpoints
        case clientName
        case username
        case password
        case certificate
        case certKey
        case requestTimeout
        case dialTimeout
        case dialKeepAliveTime
        case dialKeepAliveTimeout
        case autoSyncInterval
        case autoPing
        case autoName
        case autoSession
        case autoConnect
        case createAt
        case updateAt
        case status
    }
}
