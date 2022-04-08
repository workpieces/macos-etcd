//
//  ETCDItem.swift
//  etcd
//
//  Created by FaceBook on 2022/3/27.
//  Copyright © 2022 Workpiece. All rights reserved.
//

import Foundation

class ETCDItem : Identifiable{
    var id = UUID()
    var directory: String
    var fileValue: String?
    var children: [ETCDItem] = []
    weak var parent: ETCDItem?
    
    init(directory: String) {
        self.directory = directory
    }
    
    func add(child: ETCDItem) {
        children.append(child)
        child.parent = self
    }
}

func coverItem(etcdRoot:ETCDItem ,dir: [String], count:Int ,value:String)->ETCDItem {
    if count >= (dir.count - 1) {
        let root = ETCDItem.init(directory: dir[count])
        root.fileValue = value
        return root
    }
    let root = ETCDItem.init(directory: dir[count])
    root.add(child: coverItem(etcdRoot: root, dir: dir, count: count+1,value: value))
    return root
}
