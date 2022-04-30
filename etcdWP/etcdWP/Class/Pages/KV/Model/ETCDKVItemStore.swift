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
            KVOperateModel.init(name: "用户管理", english: "（Roles）",type: 4),
//            KVOperateModel.init(name: "移除租约", english: "（LeaseRevoke）",type: 3),
//            KVOperateModel.init(name: "租约列表", english: "（LeaseList）",type: 4),
//            KVOperateModel.init(name: "租约存活一次", english: "（KeepAliveOnce）",type: 5),
//            KVOperateModel.init(name: "角色列表", english: "（Roles）",type: 6),
//            KVOperateModel.init(name: "创建角色", english: "（RoleAdd）",type: 7),
//            KVOperateModel.init(name: "删除角色", english: "（RoleAdd）",type: 8),
//            KVOperateModel.init(name: "授予角色权限", english: "（Permission）",type: 9),
//            KVOperateModel.init(name: "用户列表", english: "（Users）",type: 10),
//            KVOperateModel.init(name: "创建用户", english: "（UserAdd）",type: 11),
//            KVOperateModel.init(name: "删除用户", english: "（DeleteUser）",type: 12),
//            KVOperateModel.init(name: "查看用户", english: "（GetUser）",type: 13),
//            KVOperateModel.init(name: "修改密码", english: "（ChangePassword）",type: 14),
//            KVOperateModel.init(name: "用户角色绑定", english: "（GrantUserRole）",type: 15),
//            KVOperateModel.init(name: "用户角色解绑", english: "（UserRoleRevokes）",type: 16),
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
    @Published var c : EtcdKVClient?
    @Published var address: String
    @Published var status: Bool
    @Published var realeadData: KVRealoadData
    @Published var showFormat: ShowFormat = .List
    init(c: EtcdKVClient?,address: String,status: Bool) {
        self.c  = c
        self.address = address
        self.status = status
        self.realeadData = KVRealoadData.init(ks: [], mms: [])
    }
}

struct KVRealoadData {
    var  kvs : [KVData]
    var  currentKv: KVData?
    var  members : [KVData]
    var  temp : [KVData]
    let  offset : Int = 20
    var  page : Int = 1
    var kvCount: Int = 0
    var memberCount: Int = 0
    
    init(ks : [KVData],mms : [KVData]) {
        self.kvs = []
        self.members = []
        self.temp = []
        self.kvs.append(contentsOf:ks)
        self.members.append(contentsOf: mms)
        self.kvCount = ks.count
        self.memberCount = mms.count
        self.temp.append(contentsOf:ks)
        self.currentKv = self.kvs.first
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
    
    func KVReaload(){
        let kd = self.GetALL()
        let md = self.MemberList()
        self.realeadData =  KVRealoadData.init(ks: kd, mms: md)
        if self.realeadData.kvCount > self.realeadData.offset {
            let tmp = self.realeadData.kvs[0..<self.realeadData.offset]
            self.realeadData.kvs.removeAll()
            self.realeadData.kvs.append(contentsOf: tmp)
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
        let result = c?.getALL()
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
        let result = c?.get(key, getConsistency: getConsistency)
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
        let result = c?.getPrefix(key)
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
        let result = c?.put(key, value: value)
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
        let result = c?.keepAliveOnce(leaseid)
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
        let result = c?.put(withTTL: key, value: value, ttl: ttl)
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
        let result = c?.putKey(withLease: key, value: value, leaseid: leasid)
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
        let result = c?.putKey(withAliveOnce: key, value: value, leaseid: leasid)
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
        let result = c?.deleteALL()
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
        let result = c?.delete(key)
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
        let result = c?.grant(ttl)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg  = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "creat")
            ETCDLogsObject.shared.logSubjec.send(lg)
            if resp?.status != 200 {
                return nil
            }
            return resp ?? nil
        }
        return nil
    }
    func LeaseRevoke(leaseid: Int) -> ETCDKeyValue? {
        let result = c?.revoke(leaseid)
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
    func LeaseList() -> ETCDKeyValue? {
        let result = c?.leaseList()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg  = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "GET")
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
        let result = c?.endpointStatus()
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
        let result = c?.memberList()
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
        let result = c?.memberAdd(endpoint, learner: learner)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let  lg =  KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "add")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
    
    func MemberRemove(id: Int) -> ETCDKeyValue? {
        let result = c?.memberRemove(id)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "MEMBER")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
    func MemberUpdate(id: Int,peerUrl: String) ->ETCDKeyValue? {
        let result = c?.memberUpdate(id, peerUrl: peerUrl)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "MEMBER")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
    func MemberPromotes(id: Int) ->ETCDKeyValue? {
        let result = c?.promotes(id)
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
   
    func RolesList()-> [ETCDRoleDetailModel]{
        let result = c?.roles()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDRoleModel.self, from: result!)
            if resp?.status != 200 {
                return []
            }
            return resp?.datas ?? []
        }
        return []
    }
    
    func removeRole(roleId: String) -> ETCDRoleModel? {
        
        let result = c?.deleteRole(roleId)
        
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDRoleModel.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "deleteRole")
            ETCDLogsObject.shared.logSubjec.send(lg)
            
            return resp
        }
        return nil
    }
    
    
    func createRole(roleId: String) -> ETCDRoleModel?{
        
        let result = c?.roleAdd(roleId)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDRoleModel.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "roleAdd")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
    
}


//users
extension ItemStore {
   
    func UsersList()-> [ETCDRoleDetailModel]{
        let result = c?.users()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDRoleModel.self, from: result!)
            if resp?.status != 200 {
                return []
            }
            return resp?.datas ?? []
        }
        return []
    }
    
    func removeUser(user: String) -> ETCDRoleModel? {
        
        let result = c?.deleteUser(user)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDRoleModel.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "deleteRole")
            ETCDLogsObject.shared.logSubjec.send(lg)
            
            return resp
        }
        return nil
    }
    
    
    func addUser(user: String,password:String) -> ETCDRoleModel?{
        
        let result = c?.userAdd(user, password: password)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDRoleModel.self, from: result!)
            let lg = KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "roleAdd")
            ETCDLogsObject.shared.logSubjec.send(lg)
            return resp
        }
        return nil
    }
    
}
