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
    
    func children() -> [PairStore]? {
        do {
            let data = try? c?.children()
            if ((data?.isEmpty) != nil) {
                let pairs = try JSONDecoder().decode(PairStore.self, from: data!)
                return  [pairs]
            }
            return []
        } catch  {
            print(error)
            return []
        }
    }
}
