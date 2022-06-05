//
//  KvModel.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/26.
//

import SwiftUI
import MacosEtcd
import Combine

// 键值操作类型
struct KVOperateModel: Identifiable,Hashable {
    var id = UUID()
    var name: String
    var english: String
    var type: Int
    
    static  func getItems() -> [KVOperateModel]{
        let operateModels : [KVOperateModel] = [
            KVOperateModel.init(name: "创建键值", english: "（PutWithTTL）",type: 0),
            KVOperateModel.init(name: "键值前缀删除", english: "（DeletePrefix）",type: 1),
            KVOperateModel.init(name: "租约管理", english: "（LeaseGrant）",type: 2),
            KVOperateModel.init(name: "角色管理", english: "（Roles）",type: 3),
            KVOperateModel.init(name: "用户管理", english: "（Users）",type: 4),
            KVOperateModel.init(name: "开启认证", english: "（AuthEnable）",type: 5),
        ]
        return operateModels
    }
}

// 成员类型
struct KVMemberModel: Identifiable,Hashable {
    var id = UUID()
    var name: String
    var type: Int
    
    static func getMembers() -> [KVMemberModel] {
        let members : [KVMemberModel] = [
            KVMemberModel.init(name: "创建成员", type: 0),
            KVMemberModel.init(name: "修改成员", type: 1),
            KVMemberModel.init(name: "提升成员", type: 2),
        ]
        return members
    }
}

// 树形或者平铺展示格式
enum ShowFormat: String {
    case List  = "平铺结构" // 平铺结构
    case Tree  = "树形结构" // 树形结构
    
    func Name() -> String {
        switch self {
        case .List: return rawValue
        case .Tree: return rawValue
        }
    }
}

// 导入导出数据格式
struct OutKvModel: Codable {
    var key : String
    var value: String
}

// 状态管理类型
class ItemStore: ObservableObject {
    @Published var c : EtcdClientOption
    @Published var realeadData: KVRealoadData
    @Published var showFormat: ShowFormat = .List
    init(c: EtcdClientOption) {
        self.c = c

        self.realeadData = KVRealoadData.init(ks: [], mms: [],currentKv: nil)
    }
}

// 分页刷新管理状态
struct KVRealoadData {
    var  kvs : [KVData]
    var  currentKv: KVData?
    var  members : [KVData]
    var  temp : [KVData]
    let  offset : Int = 20
    var  page : Int = 1
    var kvCount: Int = 0
    var memberCount: Int = 0
    
    init(ks : [KVData],mms : [KVData],currentKv:KVData?) {
        self.kvs = []
        self.members = []
        self.temp = []
        self.kvs.append(contentsOf:ks)
        self.members.append(contentsOf: mms)
        self.kvCount = ks.count
        self.memberCount = mms.count
        self.temp.append(contentsOf:ks)
        if currentKv != nil {
            self.currentKv = currentKv
        }else{
            self.currentKv = self.kvs.first
        }
    }
    
    func GetMemberCount() -> Int {
        return self.memberCount
    }
    
    func GetKvCount() -> Int{
        return self.kvCount
    }
    
    func GetCurrentPage() -> Int {
        if self.page == 0 {
            return 1
        }else {
            return self.page
        }
    }
    
    func GetKey() -> String {
        return (self.currentKv?.key)!
    }
}

// Reload
extension ItemStore {
    
    func Next() {
        let currentIndex = self.realeadData.page
        let count = self.realeadData.GetKvCount()
        if count != 0 {
            let last = count - currentIndex*self.realeadData.offset
            if last > 0 {
                self.realeadData.page += 1
                // maybe bug ?
                if currentIndex != self.realeadData.page{
                    self.realeadData.kvs = self.realeadData.temp
                    // 判断是不是最后一页
                    let mod = count / self.realeadData.offset
                    if self.realeadData.page > mod {
                        let tmp  = self.realeadData.kvs[(self.realeadData.page-1)*self.realeadData.offset..<count]
                        self.realeadData.kvs.removeAll()
                        self.realeadData.kvs.append(contentsOf: tmp)
                    }else {
                        let tmp  = self.realeadData.kvs[(self.realeadData.page-1)*self.realeadData.offset..<self.realeadData.page*self.realeadData.offset]
                        self.realeadData.kvs.removeAll()
                        self.realeadData.kvs.append(contentsOf: tmp)
                    }
                }
            }
        }
    }
    
    func Last() {
        let currentIndex = self.realeadData.page
        let count = self.realeadData.GetKvCount()
        if count != 0 {
            if self.realeadData.page != 1 {
                self.realeadData.page -= 1
                if currentIndex != self.realeadData.page{
                    self.realeadData.kvs = self.realeadData.temp
                    let tmp  = self.realeadData.kvs[(self.realeadData.page-1)*self.realeadData.offset..<self.realeadData.page*self.realeadData.offset]
                    self.realeadData.kvs.removeAll()
                    self.realeadData.kvs.append(contentsOf: tmp)
                }
            }else{
                self.realeadData.page = 1
            }
        }
    }
    
    func KVReaload( _ newValue:Bool){
        let kd = self.GetALL()
        let md = self.MemberList()
        self.realeadData =  KVRealoadData.init(ks: kd, mms: md,currentKv: newValue ? nil :self.realeadData.currentKv )
        if self.realeadData.kvCount > self.realeadData.offset {
            let tmp = self.realeadData.kvs[0..<self.realeadData.offset]
            self.realeadData.kvs.removeAll()
            self.realeadData.kvs.append(contentsOf: tmp)
        }
    }
    
    // 开启服务
    func Open() throws {
        guard c.etcdClient != nil && c.etcdClient!.ping() else {
            Task.detached(priority: .utility) {
                async   let client =  EtcdNewKVClient(self.c.endpoints.joined(separator: ","),
                                              self.c.username,
                                              self.c.password,
                                              self.c.certFile,
                                              self.c.keyFile,
                                              self.c.caFile,
                                              self.c.requestTimeout ,
                                              self.c.dialTimeout ,
                                              self.c.dialKeepAliveTime ,
                                              self.c.dialKeepAliveTimeout ,
                                              self.c.autoSyncInterval ,
                                              nil)
                if await client == nil {
                    throw NSError.init(domain: "开启服务失败，请重试", code: 400)
                }
                await self.c.etcdClient = client
                 self.c.status = true
            }
            return
        }
    }
    
    func Close() throws {
        guard c.etcdClient == nil else {
            try c.etcdClient?.close()
            c.etcdClient = nil
            c.status = false
            return
        }
    }
}

// Operate Logs
extension ItemStore {
    func InsertLogs(status: Int ,message: String,operate: String) {
        let lg = KVOperateLog.init(status: status, message: message , operate: operate)
        ETCDLogsObject.shared.logSubjec.send(lg)
    }
}

// GET
extension ItemStore {
    func GetALL() -> [KVData] {
        let result = c.etcdClient?.getALL()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            self.InsertLogs(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "GET")
            if resp?.status != 200 {
                return []
            }
    
            return resp?.datas ?? []
        }
        return []
    }
    // getConsistency s -> json l -> plain
    func Get(key: String,getConsistency: String = "s") -> [KVData] {
        let result = c.etcdClient?.get(key, getConsistency: getConsistency)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            self.InsertLogs(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "GET")
            if resp?.status != 200 {
                return []
            }
            return resp?.datas ?? []
        }
        return []
    }
    func GetPrefix(key: String) -> [KVData] {
        let result = c.etcdClient?.getPrefix(key)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            self.InsertLogs(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "GET")
            if resp?.status != 200 {
                return []
            }
            return resp?.datas ?? []
        }
        return []
    }
}

// PUT
extension ItemStore {
    func Put(key: String,value: String) ->ETCDKeyValue? {
        let result = c.etcdClient?.put(key, value: value)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "PUT")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
    
    
    
    func keepAliveOnce(leaseid:Int) ->ETCDKeyValue? {
        let result = c.etcdClient?.keepAliveOnce(leaseid)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "keepAliveOnce")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
    
    func PutWithTTL(key: String,value: String,ttl: Int) ->ETCDKeyValue? {
        let result = c.etcdClient?.put(withTTL: key, value: value, ttl: ttl)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "PUT")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
    
    func PutKeyWithLease(key: String,value: String,leasid: Int) -> ETCDKeyValue? {
        let result = c.etcdClient?.putKey(withLease: key, value: value, leaseid: leasid)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "PUT")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
    
    func PutKeyWithAliveOnce(key: String,value: String,leasid: Int) -> ETCDKeyValue? {
        let result = c.etcdClient?.putKey(withAliveOnce: key, value: value, leaseid: leasid)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "PUT")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
}

// Delete
extension ItemStore {
    func DeleteALL() -> ETCDKeyValue? {
        let result = c.etcdClient?.deleteALL()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg  = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "DELETE")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
    func Delete(key: String) -> ETCDKeyValue? {
        let result = c.etcdClient?.delete(key)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg  = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "DELETE")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
    
    
    func DeletePrefix(key: String) -> ETCDKeyValue? {
        let result = c.etcdClient?.deletePrefix(key)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg  = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "DELETE")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
}

// lease
extension ItemStore {
    func LeaseGrant(ttl: Int) -> ETCDKeyValue? {
        let result = c.etcdClient?.grant(ttl)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg  = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "LEASE")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
    func LeaseRevoke(leaseid: String) -> ETCDKeyValue? {
        let result = c.etcdClient?.leaseRevoke(leaseid)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg  = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "LEASE")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
    func LeaseList() -> ETCDKeyValue? {
        let result = c.etcdClient?.leaseList()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg  = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "LEASE")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
}

// Endpoint
extension ItemStore {
    func EndpointStatus() -> [KVData] {
        let result = c.etcdClient?.endpointStatus()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let  lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "ENDPOINT")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return []
            }
            return resp?.datas ?? []
        }
        return []
    }
}

// Members
extension ItemStore {
    func MemberList() -> [KVData] {
        let result = c.etcdClient?.memberList()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg  = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "MEMBER")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return []
            }
            return resp?.datas ?? []
        }
        return []
    }
    func MemberAdd(endpoint: String,learner: Bool) -> ETCDKeyValue? {
        let result = c.etcdClient?.memberAdd(endpoint, learner: learner)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let  lg =  KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "MEMBER")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
    
    func MemberRemove(id: String) -> ETCDKeyValue? {
        let result = c.etcdClient?.memberRemove(id)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "MEMBER")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
    func MemberUpdate(id: String,peerUrl: String) ->ETCDKeyValue? {
        let result = c.etcdClient?.memberUpdate(id, peerUrl: peerUrl)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "MEMBER")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
    func MemberPromotes(id: String) ->ETCDKeyValue? {
        let result = c.etcdClient?.promotes(id)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let  lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "MEMBER")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
}

//Roles
extension ItemStore {
    
    func RolesList()-> [KVData]?{
        let result = c.etcdClient?.roles()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            if resp?.status != 200 {
                return []
            }
            return resp?.datas
        }
        return []
    }
    
    func removeRole(roleId: String) -> ETCDKeyValue? {
        let result = c.etcdClient?.deleteRole(roleId)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "ROLE")
            ETCDLogsObject.shared.logSubjec.send(lg)
            
            return resp
        }
        return nil
    }
    
    func createRole(roleId: String) -> ETCDKeyValue?{
        
        let result = c.etcdClient?.roleAdd(roleId)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "ROLE")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
    
}


//users
extension ItemStore {
    
    func UsersList()-> [KVData]?{
        let result = c.etcdClient?.users()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            if resp?.status != 200 {
                return []
            }
            return resp?.datas
        }
        return []
    }
    
    func removeUser(user: String) -> ETCDKeyValue? {
        
        let result = c.etcdClient?.deleteUser(user)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "USER")
            ETCDLogsObject.shared.logSubjec.send(lg)
            
            return resp
        }
        return nil
    }
    
    
    func addUser(user: String,password:String) -> ETCDKeyValue?{
        
        let result = c.etcdClient?.userAdd(user, password: password)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "USER")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
    
}


//authEnable
extension ItemStore {
    
    func authEnable(enble:Bool ) -> ETCDKeyValue? {
        let result = c.etcdClient?.authEnable(enble)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "AUTHENABLE")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
    
    
}


//authEnable
extension ItemStore {
    
    func Chidren () -> [KVData] {
        let result = c.etcdClient?.children()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "tree")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp?.datas ?? []
        }
        return []
    }
    
    func treeItem () -> KVData? {
        let result = c.etcdClient?.children()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "tree")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp?.datas?.first
        }
        return nil
    }
    
    
}
