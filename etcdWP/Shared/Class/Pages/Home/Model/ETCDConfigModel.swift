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
   
    @Published var id = UUID()
    @Published var endpoints: [String] = ["127.0.0.1:2379"]
    @Published var clientName: String = "etcd-wp-\(UUID().uuidString.suffix(6))"
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var certFile: String = ""
    @Published var keyFile: String = ""
    @Published var caFile:  String = ""
    @Published var requestTimeout: Int = 5
    @Published var dialTimeout: Int = 5
    @Published var dialKeepAliveTime: Int = 10
    @Published var dialKeepAliveTimeout: Int = 3
    @Published var autoSyncInterval:Int = 5
    @Published var autoPing: Bool = true
    @Published var autoName: Bool = true
    @Published var autoSession: Bool = true
    @Published var autoConnect: Bool = true
    @Published var createAt: Date = Date()
    @Published var updateAt: Date = Date()
    @Published var status: Bool = false
    @Published var etcdClient: EtcdKVClient?
    @Published var checked:Bool = false
    
}
