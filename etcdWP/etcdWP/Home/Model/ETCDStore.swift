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
                                         item.certificate,
                                         item.certKey,
                                         item.requestTimeout ,
                                         item.dialTimeout ,
                                         item.dialKeepAliveTime ,
                                         item.dialKeepAliveTimeout ,
                                         item.autoSyncInterval ,
                                         nil)
                self.ectdClientList[idx].etcdClient = c
                if c != nil {
                    self.ectdClientList[idx].status = self.Ping(c: c!)
                }
            }else{
                self.ectdClientList[idx].status = self.Ping(c: item.etcdClient!)
            }
        }
    }
    
    func Register(item : EtcdClientOption) -> Bool {
        let c =  EtcdNewKVClient(item.endpoints.joined(separator: ","),
                                 item.username,
                                 item.password,
                                 item.certificate,
                                 item.certKey,
                                 item.requestTimeout ,
                                 item.dialTimeout ,
                                 item.dialKeepAliveTime ,
                                 item.dialKeepAliveTimeout ,
                                 item.autoSyncInterval ,
                                 nil)
        if c == nil {
            return false
        }
        return self.Ping(c: c!)
    }
}

extension HomeViewModel {    
    func Ping(c: EtcdKVClient) -> Bool {
        return c.ping()
    }
    func Close(c: EtcdKVClient) throws {
        do {
            try c.close()
        }
    }
    func CloseAll() throws {
        do {
            for item in self.ectdClientList {
                try? item.etcdClient?.close()
            }
        }
    }
}

