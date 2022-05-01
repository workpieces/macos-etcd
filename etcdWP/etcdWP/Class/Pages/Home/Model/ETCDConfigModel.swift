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
    var clientName: String = "etcd-wp-"
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
    @NotCoded var etcdClient: EtcdKVClient?
}


@propertyWrapper
public struct NotCoded<Value> {
    private var value: Value?
    
    public init(wrappedValue: Value?) {
        self.value = wrappedValue
    }
    
    public var wrappedValue: Value? {
        get { value }
        set { self.value = newValue }
    }
}

extension NotCoded: Codable {
    public func encode(to encoder: Encoder) throws {
        // Skip encoding the wrapped value.
    }
    
    public init(from decoder: Decoder) throws {
        // The wrapped value is simply initialised to nil when decoded.
        self.value = nil
    }
}
