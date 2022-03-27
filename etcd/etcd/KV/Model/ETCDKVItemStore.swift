//
//  KvModel.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/26.
//

import SwiftUI
import MacosEtcd

class ItemStore: ObservableObject {
    @Published private(set) var items: ETCDItem
    
    init(items: ETCDItem) {
        self.items = items
    }
}

extension ItemStore {
    
    static func List(c: EtcdKVClient) throws -> ItemStore {
        do {
            let data = try? c.all()
            let pairs = try JSONDecoder().decode([PairStore].self, from: data!)
            let etcdRoot = ETCDItem.init(directory: "/")
            for key in pairs {
                let dir = key.key.components(separatedBy: "/")
                if dir.count > 1{
                    etcdRoot.add(child: coverItem(etcdRoot: etcdRoot, dir: dir,count: 1,value:   key.value ))
                }else{
                    etcdRoot.fileValue = key.value
                }
            }
            return ItemStore(items: etcdRoot)
        } catch {
            print(error)
            return 
        }
    }
}
