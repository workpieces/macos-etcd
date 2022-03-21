//
//  Option.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/10.
//

import Foundation
import MacosEtcd
import Combine

var encoder = JSONEncoder()
var decoder = JSONDecoder()

struct Option: Hashable {
    let title: String
    let image: String
}

let options:[Option] = [
    Option.init(title: "Home", image: "house"),
    Option.init(title: "About", image: "info.circle"),
]

class HomeViewModel: ObservableObject {
    let userDefaultsKey: String = "com.etcdclient.list"
    @Published var selectTab = "Home"
    @Published var etcdTab = "KV"
    @Published var ectdClientList: [EtcdClientOption] = []
    
    init() {
        let item  = self.GetUserDefaults()
        for data in item {
            let client = EtcdClientOption(
                endpoints: data.endpoints,
                serviceName: data.serviceName,
                username: data.username,
                password: data.password,
                cert: data.cert,
                certKey: data.certKey,
                requestTimeout: data.requestTimeout,
                dialTimeout: data.dialTimeout,
                dialKeepAliveTime: data.dialKeepAliveTime,
                dialKeepAliveTimeout: data.dialKeepAliveTimeout,
                autoSyncInterval: data.autoSyncInterval,
                createAt: Date.now,
                updateAt: Date.now,
                status: data.status)
            self.ectdClientList.append(client)
        }
    }
    
    func Append(data: EtcdClientOption) {
        let client = EtcdClientOption(
            endpoints: data.endpoints, serviceName: data.serviceName,
            username: data.username,
            password: data.password,
            cert: data.cert,
            certKey: data.certKey,
            requestTimeout: data.requestTimeout,
            dialTimeout: data.dialTimeout,
            dialKeepAliveTime: data.dialKeepAliveTime,
            autoSyncInterval: data.autoSyncInterval,
            createAt: Date.now,
            updateAt: Date.now,
            status: data.status)
        self.ectdClientList.append(client)
        self.SetUserDefaults()
    }
    
    func FindByName(serviceName: String) ->Bool {
        for item in self.ectdClientList {
            if item.serviceName == serviceName {
                return true
            }
        }
        return false
    }
    
    func GetUUID(idx: Int) -> UUID {
        return self.ectdClientList[idx].id
    }
    
    func GetEtcdClientList(idx: Int) -> EtcdClientOption {
        return self.ectdClientList[idx]
    }
    
    func Delete(id: UUID) {
        for (idx,item) in self.ectdClientList.enumerated() {
            if item.id == id {
                self.ectdClientList.remove(at: idx)
            }
        }
        print("Delete Object length:",self.ectdClientList.count)
        self.SetUserDefaults()
    }
    
    func Update(id: UUID,newData: EtcdClientOption) {
        for (idx,item) in self.ectdClientList.enumerated() {
            if item.id == id {
                self.ectdClientList[idx].endpoints = newData.endpoints
                self.ectdClientList[idx].username = newData.username
                self.ectdClientList[idx].password = newData.password
                self.ectdClientList[idx].cert = newData.cert
                self.ectdClientList[idx].certKey = newData.certKey
                self.ectdClientList[idx].requestTimeout = newData.requestTimeout
                self.ectdClientList[idx].dialTimeout = newData.dialTimeout
                self.ectdClientList[idx].dialKeepAliveTime = newData.dialKeepAliveTime
                self.ectdClientList[idx].dialKeepAliveTimeout = newData.dialKeepAliveTimeout
                self.ectdClientList[idx].autoSyncInterval = newData.autoSyncInterval
                self.ectdClientList[idx].serviceName = newData.serviceName
                self.ectdClientList[idx].updateAt = Date.now
                self.ectdClientList[idx].status = newData.status
            }
        }
        self.SetUserDefaults()
    }
    
    func Sort() {
        self.ectdClientList.sort(by:) { (data1, data2) in
            return data1.createAt.timeIntervalSince1970 < data2.createAt.timeIntervalSince1970
        }
    }
    
    func SetUserDefaults() {
        let data = try! encoder.encode(self.ectdClientList)
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
    
    func GetUserDefaults() -> [EtcdClientOption] {
        guard let data = UserDefaults.standard.object(forKey: userDefaultsKey) else {
            return [EtcdClientOption]()
        }
        let js = try! decoder.decode([EtcdClientOption].self, from: data as! Data)
        print(" Get UserDefault Object length:",js.count)
        return js
    }
    
    func NewEtcdClient() {
        for item in self.ectdClientList {
            let c = EtcdNewKVClient(item.endpoints.joined(separator: ","),
                                    item.username,
                                    item.password,
                                    item.cert,
                                    item.certKey,
                                    item.requestTimeout,
                                    item.dialTimeout,
                                    item.dialKeepAliveTime,
                                    item.dialKeepAliveTimeout, item.autoSyncInterval, nil)
        }
    }
    
    func List(c: EtcdKVClient) {
        let data = try? c.all()
        if data != nil{
            print("data:",data)
        }
    }
    
    func Close(c: EtcdKVClient) throws {
        try c.close()
    }
}
