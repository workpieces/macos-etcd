//
//  ETCDKVMenuModel.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/8/2.
//

import SwiftUI
import Foundation

struct ETCDKVMenuModel: Identifiable,Hashable {
    var id =  UUID()
    let title: String
    let rounterName:String

}

let menuModels:[ETCDKVMenuModel] = [
    ETCDKVMenuModel.init(title: "创建键值",rounterName: ""),
    ETCDKVMenuModel.init(title: "键值前缀删除",rounterName: ""),
    ETCDKVMenuModel.init(title: "租约管理",rounterName: ""),
    ETCDKVMenuModel.init(title: "角色管理",rounterName: ""),
    ETCDKVMenuModel.init(title: "用户管理",rounterName: ""),
    ETCDKVMenuModel.init(title: "开启认证",rounterName: ""),
]

