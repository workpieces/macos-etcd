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
    init(c: EtcdKVClient?,address: String,status: Bool) {
        self.c  = c
        self.address = address
        self.status = status
    }
}

// GET
extension ItemStore {
    func GetALL() -> [KVData] {
        let result = c?.getALL()
        guard result == nil || ((result?.isEmpty) == nil) else {
            let resp = try? JSONDecoder().decode(ETCDKeyValue.self, from: result!)
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
