//
//  KvModel.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/26.
//

import SwiftUI
import MacosEtcd

class ItemStore: ObservableObject {
    @Published  var c : EtcdKVClient?
    
    init(c: EtcdKVClient?) {
        self.c  = c
    }
    
    func list() -> ETCDItem {
        do {
            let data = try? c?.all()
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
            return etcdRoot
        } catch let error {
            print(error)
            return  ETCDItem.init(directory: "/")
        }
    }
    
    func all() -> [PairStore] {
        do {
            let data = try? c?.all()
            let pairs = try JSONDecoder().decode([PairStore].self, from: data!)
            return pairs
        } catch  {
            print(error)
            return [PairStore]()
        }        
    }
}
