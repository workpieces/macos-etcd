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
    @Published var ectdClientList: [EtcdClientOption] = []
    
    init() {
        // 初始化服务UserDefault
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
    }
    
    //获取版本
    func getVersion() ->  String {
        let infoDic = Bundle.main.infoDictionary
        return infoDic?["CFBundleShortVersionString"] as! String
    }
    
    // 连接状态
    func Ping(c: EtcdKVClient) -> Bool {
        return c.ping()
    }
    
    // 关闭服务
    func Close(c: EtcdKVClient) throws {
        do {
            try c.close()
        }
    }
    
    // 关闭所有服务
    func CloseAll() throws {
        do {
            for item in self.ectdClientList {
                try? item.etcdClient?.close()
            }
        }
    }
    
    // 注册服务
    func Register(item : EtcdClientOption) throws {
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
        if c == nil || !self.Ping(c: c!) {
            throw NSError.init(domain: "服务连接异常", code: 400)
        }
    }
    
    // 监听服务
    // copy from https://stackoverflow.com/questions/71849684/swiftui-concurrency-run-activity-only-on-background-thread
    func WatchListenEtcdClient() async {
        Task.detached(priority: .medium) {
            for (idx,item) in self.ectdClientList.enumerated() {
                if item.etcdClient == nil{
                    // todo  卡顿
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
                    if c != nil {
                        // todo 卡顿
                        await MainActor.run {
                            self.ectdClientList[idx].etcdClient = c
                            self.ectdClientList[idx].status = self.Ping(c: c!)
                        }
                    }else{
                        await MainActor.run {
                            self.ectdClientList[idx].etcdClient = c
                            self.ectdClientList[idx].status  = false
                        }
                    }
                }else{
                    await MainActor.run {
                        self.ectdClientList[idx].status = self.Ping(c: item.etcdClient!)
                    }
                }
              
            }
    
        }
    }
}
