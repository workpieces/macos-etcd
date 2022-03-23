//
//  EtcdViewModel.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/13.
//

import Foundation
import MacosEtcd

let etcds:[Option] = [
    Option.init(title: "KV", image: "antenna.radiowaves.left.and.right"),
    Option.init(title: "Authorize", image: "lock.icloud.fill"),
    Option.init(title: "Members", image: "person.3"),
]

struct EtcdClientOption: Identifiable,Codable {
    var id = UUID()
    var endpoints: [String]
    var serviceName: String
    var username: String = ""
    var password: String = ""
    var cert: String = ""
    var certKey: String = ""
    var requestTimeout: Int = 5
    var dialTimeout: Int = 5
    var dialKeepAliveTime: Int = 5
    var dialKeepAliveTimeout: Int = 3
    var autoSyncInterval:Int = 3
    var createAt: Date = Date.now
    var updateAt: Date = Date.now
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


struct EtcdKvItem:  Hashable, Identifiable, CustomStringConvertible {
    var id: Self { self }
    var name: String
    var children: [EtcdKvItem]? = nil
    var description: String {
        switch children {
        case nil:
            return "📄 \(name)"
        case .some(let children):
            return children.isEmpty ? "📂 \(name)" : "📁 \(name)"
        }
    }
}
