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
    @Published var logs: [KVOperateLog] = []
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
//            self.InsertLogs(status: resp?.status ?? 200, message: resp?.message ?? "OK", operate: resp?.operate ?? "GET")
            return resp?.datas ?? []
        }
        return []
    }
}


// Delete
extension ItemStore {
    func DeleteALL() -> ETCDKeyValue? {
        let result = c?.deleteALL()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
            return resp ?? nil
        }
        return nil
    }
    func Delete(key: String) -> ETCDKeyValue? {
        let result = c?.delete(key)
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
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
            return resp?.datas ?? []
        }
        return []
    }
}
