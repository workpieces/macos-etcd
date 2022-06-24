//
//  EtcdViewModel.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/13.
//

import Foundation
import MacosEtcd

struct EtcdClientOption: Identifiable,Codable,Equatable,Hashable {
    var id = UUID()
    var endpoints: [String] = ["127.0.0.1:2379"]
    var clientName: String = "etcd-wp-\(UUID().uuidString.suffix(6))"
    var username: String = ""
    var password: String = ""
    var certFile: String = ""
    var keyFile: String = ""
    var caFile:  String = ""
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
    var checked:Bool = false
    enum CodingKeys: String, CodingKey {
        case endpoints
        case clientName
        case username
        case password
        case certFile
        case keyFile
        case caFile
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
    
    var hashValue: Int {
        return id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool{
        lhs.id == rhs.id
    }
    
    func getEndpoints () -> [String]{
        
        var newEndpoints :[String] = []
        
        let  endpoints =  self.endpoints.first!.components(separatedBy: ",")
        
        for (index, item) in endpoints.enumerated() {
            if index <= 2{
                newEndpoints.append(item)
            }
        }
        guard newEndpoints.count < 3 else {
            newEndpoints.append("...")
            return newEndpoints
        }
        return newEndpoints
            
    }
}




class ETCDConfigModel: ObservableObject {
   
    var id = UUID()
    var endpoints: [String] = ["127.0.0.1:2379"]
    var clientName: String = "etcd-wp-\(UUID().uuidString.suffix(6))"
    var username: String = ""
    var password: String = ""
    var certFile: String = ""
    var keyFile: String = ""
    var caFile:  String = ""
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
    var checked:Bool = false
    
}
