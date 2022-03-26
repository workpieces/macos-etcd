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
}
