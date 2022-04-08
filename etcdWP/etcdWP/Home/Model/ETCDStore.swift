//
//  HomeEtcdStore.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/26.
//

import SwiftUI
import MacosEtcd

// 主要用于处理etcd服务健康检查及服务开启关闭
extension HomeViewModel {
    // watch 监听etcd客户端
    func WatchListenEtcdClient() {
        for (idx,item) in self.ectdClientList.enumerated() {
            if item.etcdClient == nil{
                let c =  EtcdNewKVClient(item.endpoints.joined(separator: ","),
                                         item.username,
                                         item.password,
                                         item.cert,
                                         item.certKey,
                                         item.requestTimeout,
                                         item.dialTimeout,
                                         item.dialKeepAliveTime,
                                         item.dialKeepAliveTimeout, item.autoSyncInterval, nil)
                self.ectdClientList[idx].etcdClient = c
            }else{
                let ok =  self.Ping(c: item.etcdClient!)
                if ok {
                    self.ectdClientList[idx].status = true
                }else{
                    self.ectdClientList[idx].status = false
                }
            }
        }
    }
    
    // 检测etcd是否健康
    func Ping(c: EtcdKVClient) -> Bool {
        var ok : Bool = true
        do {
            try c.endPointHealth()
        } catch {
            print(error)
            ok = false
        }
        return ok
    }
    
    // 关闭指定的etcd客户端服务
    func Close(c: EtcdKVClient) throws {
        do {
            try c.close()
        }
    }
    
    // 关闭所有的etcd客户端服务
    func CloseAll() throws {
        do {
            for item in self.ectdClientList {
                try? item.etcdClient?.close()
            }
        }
    }
}

