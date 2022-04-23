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
    @Published var status: Bool
    @Published var relead: Bool = false
    private var logs: [KVOperateLog] = []
    init(c: EtcdKVClient?,address: String,status: Bool) {
        self.c  = c
        self.address = address
        self.status = status
    }
}

// Reload
extension ItemStore {
    func Reaload()  {
        self.relead = !self.relead
    }
}

// Operate Logs
extension ItemStore {
    func InsertLogs(status: Int ,message: String,operate: String) {
        self.logs.removeAll()
        let lg = KVOperateLog.init(status: status, message: message , operate: operate)
        self.logs.append(lg)
    }
    func GetLogs() -> [KVOperateLog] {
        guard self.logs.isEmpty else {
            return self.logs
        }
        return []
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
    func Put(key: String,value: String) -> [KVData] {
        let result = c?.put(key, value: value)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            self.InsertLogs(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "PUT")
            if resp?.status != 200 {
                return []
            }
            return resp?.datas ?? []
        }
        return []
    }
    
    func PutWithTTL(key: String,value: String,ttl: Int) ->ETCDKeyValue? {
        let result = c?.put(withTTL: key, value: value, ttl: ttl)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            self.logs.append(KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "PUT"))
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
            self.logs.append(KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "PUT"))
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
            self.logs.append(KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "PUT"))
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
            self.logs.append(KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "DELETE"))
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
            self.logs.append(KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "DELETE"))
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
            self.logs.append(KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "DELETE"))
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
            self.logs.append(KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "ENDPOINT"))
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
            self.logs.append(KVOperateLog.init(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "MEMBER"))
            if resp?.status != 200 {
                return []
            }
            return resp?.datas ?? []
        }
        return []
    }
}
