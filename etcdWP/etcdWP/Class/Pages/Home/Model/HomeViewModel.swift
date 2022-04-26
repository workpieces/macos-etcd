//
//  Option.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/10.
//

import Foundation
import MacosEtcd

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
                clientName: data.clientName,
                username: data.username,
                password: data.password,
                certificate: data.certificate,
                certKey: data.certKey,
                requestTimeout: data.requestTimeout,
                dialTimeout: data.dialTimeout,
                dialKeepAliveTime: data.dialKeepAliveTime,
                dialKeepAliveTimeout: data.dialKeepAliveTimeout,
                autoSyncInterval: data.autoSyncInterval,
                createAt: Date(),
                updateAt: Date(),
                status: data.status)
            self.ectdClientList.append(client)
        }
        // 一启动就创建客户端
        self.WatchListenEtcdClient()
    }
}
