//
//  KvModel.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/26.
//

import SwiftUI
import MacosEtcd

class ItemStore: ObservableObject {
    @Published var c : EtcdKVClient?
    @Published var address: String
    init(c: EtcdKVClient?,address: String) {
        self.c  = c
        self.address = address
    }
}

// key value store KV键值存储
extension ItemStore {
    //  获取所有键值
    func All() -> [PairStore] {
        do {
            let data = try? c?.all()
            if ((data?.isEmpty) != nil) {
                let pairs = try JSONDecoder().decode([PairStore].self, from: data!)
                return  pairs
            }
            return []
        } catch {
            return []
        }
    }
    
    // 树形展示KV
    func Children() -> [PairStore]{
        do {
            let data = try? c?.children()
            if ((data?.isEmpty) != nil) {
                let pairs = try JSONDecoder().decode(PairStore.self, from: data!)
                return  [pairs]
            }
            return []
        } catch  {
            return []
        }
    }
    
    
    // 获取指定Key的Value
    func Get(key: String) -> PairStore? {
        do {
            let data = try? c?.get(key)
            if data?.isEmpty != nil {
                let pairs = try JSONDecoder().decode(PairStore.self, from: data!)
                return pairs
            }
            return nil
        } catch  {
            return nil
        }
    }
    
    // 根据key前缀获取批量键值
    func GetPrefix(pre: String) -> [PairStore] {
        do {
            let data = try? c?.getPrefix(pre)
            if ((data?.isEmpty) != nil) {
                let pairs = try JSONDecoder().decode(PairStore.self, from: data!)
                return  [pairs]
            }
            return []
        } catch  {
            return []
        }
    }
    
    // 排序根据key前缀获取批量键值
    func SortPrefix(pre: String,sort: Int) -> [PairStore] {
        do {
            let data = try? c?.sortPrefix(sort, prefix: pre)
            if ((data?.isEmpty) != nil) {
                let pairs = try JSONDecoder().decode(PairStore.self, from: data!)
                return  [pairs]
            }
            return []
        } catch  {
            return []
        }
    }
    
    // 添加键值
    func Put(key: String,value: String) throws {
        try c?.put(key, value: value)
    }
    
    // 添加键值+ttl
    func PutKeyWithTTL(key: String,value: String,ttl: Int) throws {
        try c?.putKey(withTTL: key, value: value, ttl: ttl)
    }
    
    // 添加键值+租约id
    func PutKeyWithLease(key: String,value: String,leaseid: Int) throws {
        try c?.putKey(withLease: key, value: value, leaseid: leaseid)
    }
    
    // 添加键值+租约+存活一次
    func PutKeyWithAliveOnce(key: String,value: String,leaseid: Int) throws {
        try c?.putKey(withAliveOnce: key, value: value, leaseid: leaseid)
    }
    
    // 删除键值
    func Delete(key: String) throws{
        try c?.delete(key)
    }
    
    // 删除所有键值
    func DeleteAll() throws {
        try self.c?.deleteAll()
    }
    
    // 根据前缀删除
    func DeletePrefix(pre: String) throws {
        try c?.deletePrefix(pre)
    }
    
    // 获取租约id
    func Grant(ttl: Int) -> Int?{
         c?.grant(ttl)
    }
    
    //撤销租约
    func Revoke(leaseid: Int) throws {
        try c?.revoke(leaseid)
    }
}

// AuthorizesStore 授权认证
extension ItemStore {
    // 获取所有角色
    func Roles() -> [String] {
        do {
            let data = try? c?.roles()
            if ((data?.isEmpty) != nil) {
                let roles = try JSONDecoder().decode([String].self, from: data!)
                return roles
            }
            return []
        } catch  {
            return []
        }
    }
    
    // 获取所有用户
    func Users() -> [String] {
        do {
            let data = try? c?.users()
            if ((data?.isEmpty) != nil) {
                let usrs = try JSONDecoder().decode([String].self, from: data!)
                return usrs
            }
            return []
        } catch  {
            return []
        }
    }
    
    // 创建角色
    func RoleAdd(role : String) throws {
        try? c?.roleAdd(role)
    }
    
    // 删除角色
    func DeleteRole(role: String) throws {
        try? c?.deleteRole(role)
    }
    
    // 创建用户
    func UserAdd(usr: String,password:String) throws {
        try? c?.userAdd(usr, password: password)
    }
    
    // 删除用户
    func DeleteUser(usr: String) throws {
        try? c?.deleteUser(usr)
    }
    
    // Grant authorize roles to user.
    func AuthGrant(usr: String,role: String) throws {
        try? c?.authGrant(usr, role: role)
    }
    
    // Permission
    func Permission(role: String,key: String,end: String) throws {
        try? c?.permission(role, key: key, end: end)
    }
    
    // 开启认证
    func AuthEnable(enable: Bool) throws {
        try? c?.authEnable(enable)
    }
}


// ClusterStore 集群服务
extension ItemStore {
    // 集群成员列表
    func MemberList() -> [Cluster]{
        do {
            let data = try? c?.memberList()
            if ((data?.isEmpty) != nil) {
                let clusters = try JSONDecoder().decode([Cluster].self, from: data!)
                return clusters
            }
            return []
        } catch  {
            return []
        }
    }
    
    // 添加集群成员 (以,号分割)
    func MemberAdd(eps: String) throws{
        
    }
    
    // 移除集群成员
    func MemberRemove(ep: String) throws {
        
    }
    
    // 更新集群成员
    func MemberUpdate(id: Int,peerUrl: String) throws{
        
    }
}
