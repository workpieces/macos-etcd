//
//  HomeClientStore.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/26.
//

import SwiftUI
var encoder = JSONEncoder()
var decoder = JSONDecoder()

// 主要用于存储和获取etcd客户端，增删改查操作
extension HomeViewModel {
    func Append(data: EtcdClientOption) {
        let client = EtcdClientOption(
            endpoints: data.endpoints,
            clientName: data.clientName,
            username: data.username,
            password: data.password,
            certificate: data.certificate,
            certKey: data.certKey,
            requestTimeout: data.requestTimeout,
            dialTimeout: data.dialTimeout,
            dialKeepAliveTime: data.dialKeepAliveTime,
            autoSyncInterval: data.autoSyncInterval,
            createAt: Date(),
            updateAt: Date(),
            status: data.status)
        self.ectdClientList.append(client)
        self.SetUserDefaults()
    }
    
    func FindByName(serviceName: String) ->Bool {
        for item in self.ectdClientList {
            if item.clientName == serviceName {
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
        self.SetUserDefaults()
    }
    
    func Update(id: UUID,newData: EtcdClientOption) {
        for (idx,item) in self.ectdClientList.enumerated() {
            if item.id == id {
                self.ectdClientList[idx].endpoints = newData.endpoints
                self.ectdClientList[idx].username = newData.username
                self.ectdClientList[idx].password = newData.password
                self.ectdClientList[idx].certificate = newData.certificate
                self.ectdClientList[idx].certKey = newData.certKey
                self.ectdClientList[idx].requestTimeout = newData.requestTimeout
                self.ectdClientList[idx].dialTimeout = newData.dialTimeout
                self.ectdClientList[idx].dialKeepAliveTime = newData.dialKeepAliveTime
                self.ectdClientList[idx].dialKeepAliveTimeout = newData.dialKeepAliveTimeout
                self.ectdClientList[idx].autoSyncInterval = newData.autoSyncInterval
                self.ectdClientList[idx].clientName = newData.clientName
                self.ectdClientList[idx].updateAt = Date()
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
        let js = try? decoder.decode([EtcdClientOption].self, from: data as! Data)
        if js == nil{
            return []
        }
        return js!
    }
}
