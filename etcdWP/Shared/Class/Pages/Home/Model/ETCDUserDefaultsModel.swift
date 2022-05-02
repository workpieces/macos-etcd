//
//  HomeClientStore.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/26.
//

import SwiftUI

var encoder = JSONEncoder()
var decoder = JSONDecoder()

extension HomeViewModel {
    // 追加UserDefaults
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
    
    // 判断当前服务名称是否存在
    func FindByName(serviceName: String) ->Bool {
        for item in self.ectdClientList {
            if item.clientName == serviceName {
                return true
            }
        }
        return false
    }
    
    // 获取UUID
    func GetUUID(idx: Int) -> UUID {
        return self.ectdClientList[idx].id
    }
    
    // 根据指定下标获取配置
    func GetEtcdClientList(idx: Int) -> EtcdClientOption {
        return self.ectdClientList[idx]
    }
    
    // 根据uuid删除指定的UserDeafult
    func Delete(id: UUID) {
        for (idx,item) in self.ectdClientList.enumerated() {
            if item.id == id {
                self.ectdClientList.remove(at: idx)
            }
        }
        self.SetUserDefaults()
    }
    
    // 更新本地存储
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
    
    // 根据创建事件排序
    func Sort() {
        self.ectdClientList.sort(by:) { (data1, data2) in
            return data1.createAt.timeIntervalSince1970 < data2.createAt.timeIntervalSince1970
        }
    }
    
    // 保存本地存储
    func SetUserDefaults() {
        let data = try! encoder.encode(self.ectdClientList)
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
    
    // 获取本地存储
    func GetUserDefaults() -> [EtcdClientOption] {
        guard let data = UserDefaults.standard.object(forKey: userDefaultsKey) else {
            return []
        }
        let js = try? decoder.decode([EtcdClientOption].self, from: data as! Data)
        guard ((js?.isEmpty) != nil) else {
            return []
        }
        return js!
    }
}
