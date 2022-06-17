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
    @Published var allStart:Bool = false
    @Published var selectedItems:[EtcdClientOption] = []
    var error: NSError?
    @Published var reload:Bool = true
    init()  {
        // 初始化服务UserDefault
        let item  = self.GetUserDefaults()
        for data in item {
            let client = EtcdClientOption(
                endpoints: data.endpoints,
                clientName: data.clientName,
                username: data.username,
                password: data.password,
                certFile: data.certFile,
                keyFile: data.keyFile,
                caFile: data.caFile,
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
    
    // 开启单个服务 （根据uuid）
    @MainActor
    func OpenUseUUID(uuid : String) throws {
        Task.detached(priority: .utility) { [self] in
            for (idx,item) in self.ectdClientList.enumerated() {
                if item.id.uuidString == uuid {
                    let c =  EtcdNewKVClient(item.endpoints.joined(separator: ","),
                                             item.username,
                                             item.password,
                                             item.certFile,
                                             item.keyFile,
                                             item.caFile,
                                             item.requestTimeout ,
                                             item.dialTimeout ,
                                             item.dialKeepAliveTime ,
                                             item.dialKeepAliveTimeout ,
                                             item.autoSyncInterval ,
                                             &self.error)
                    if c == nil || self.error != nil{
                        self.reload   =  false
                        throw NSError.init(domain: "\(item.clientName)开启服务异常", code: 400)
                    }
                    await MainActor.run {
                        self.reload = true
                        self.ectdClientList[idx].etcdClient = c
                    }
                }
            }
        }
    }
    
    // 关闭单个服务 （根据uuid）
    func CloseUseUUID(uuid : String) throws {
        for (idx,item) in self.ectdClientList.enumerated() {
            if item.id.uuidString == uuid {
                try item.etcdClient?.close()
                self.ectdClientList[idx].etcdClient  = nil
            }
        }
    }
    
    // 关闭服务
    func Close(c: EtcdKVClient) throws {
        try c.close()
    }
    
    // 开启所有服务
    func OpenALL() throws {
        Task.detached(priority: .utility) { [self] in
            for (idx,item) in self.ectdClientList.enumerated() {
                let c =  EtcdNewKVClient(item.endpoints.joined(separator: ","),
                                         item.username,
                                         item.password,
                                         item.certFile,
                                         item.keyFile,
                                         item.caFile,
                                         item.requestTimeout ,
                                         item.dialTimeout ,
                                         item.dialKeepAliveTime ,
                                         item.dialKeepAliveTimeout ,
                                         item.autoSyncInterval ,
                                         &self.error)
                if c == nil || error != nil{
                    self.reload = false
                    throw NSError.init(domain: "\(item.clientName)开启服务异常", code: 400)
                }
                await MainActor.run {
                    self.allStart.toggle()
                    self.reload = true
                    self.ectdClientList[idx].etcdClient = c
                }
            }
        }
    }
    
    
    // 关闭所有服务
    func CloseAll() throws {
        for item in self.ectdClientList {
            try? item.etcdClient?.close()
            self.allStart.toggle()
        }
    }
    
    // 注册服务
    @MainActor
    func Register(item : EtcdClientOption) async throws {
        async let c =  EtcdNewKVClient(item.endpoints.joined(separator: ","),
                                       item.username,
                                       item.password,
                                       item.certFile,
                                       item.keyFile,
                                       item.caFile,
                                       item.requestTimeout ,
                                       item.dialTimeout ,
                                       item.dialKeepAliveTime ,
                                       item.dialKeepAliveTimeout ,
                                       item.autoSyncInterval ,
                                       &error)
        
        
        
        if await c == nil || error != nil {
            self.reload = false;
            throw NSError.init(domain: "服务连接异常", code: 400)
            
        }
        let ping =  await self.Ping(c: c!)
        
        if !ping {
            self.reload = false;
            throw NSError.init(domain: "服务连接异常", code: 400)
        }
        
    }
    
    // 监听服务
    // copy from https://stackoverflow.com/questions/71849684/swiftui-concurrency-run-activity-only-on-background-thread
    //https://juejin.cn/post/7025261081291407373#heading-3
    @MainActor
    func WatchListenEtcdClient() async {
        for (idx,item) in self.ectdClientList.enumerated() {
            if item.etcdClient == nil{
                // todo  卡顿
                async   let c =  EtcdNewKVClient(item.endpoints.joined(separator: ","),
                                                 item.username,
                                                 item.password,
                                                 item.certFile,
                                                 item.keyFile,
                                                 item.caFile,
                                                 item.requestTimeout ,
                                                 item.dialTimeout ,
                                                 item.dialKeepAliveTime ,
                                                 item.dialKeepAliveTimeout ,
                                                 item.autoSyncInterval ,
                                                 &error)
                if await c != nil  && error == nil {
                    self.reload = true;
                    // todo 卡顿，为什么这里会不卡呢，因为c创建成功，认为服务是正常的
                    let ok : Bool = await self.Ping(c: c!)
                     await self.ectdClientList[idx].etcdClient = c
                     self.ectdClientList[idx].status = ok
                    let statut = self.ectdClientList[idx].status
                }else{
                    self.reload = false;
                    self.ectdClientList[idx].status  = false
                    let statut = self.ectdClientList[idx].status
                }
            }else{
                self.reload = true;
                let ok : Bool = self.Ping(c: item.etcdClient!)
                // todo 解决连接正常，然后断开，卡顿现象，为什么这里会卡顿呢，因为服务会重试
                 self.ectdClientList[idx].etcdClient = nil
                 self.ectdClientList[idx].status = ok
                let statut = self.ectdClientList[idx].status
            }
            
        }
    }
}
