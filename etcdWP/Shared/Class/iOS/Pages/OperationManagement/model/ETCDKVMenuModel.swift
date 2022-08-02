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
    ETCDKVMenuModel.init(title: "Home",rounterName: ""),
    ETCDKVMenuModel.init(title: "Home",rounterName: ""),
    ETCDKVMenuModel.init(title: "Home",rounterName: ""),
    ETCDKVMenuModel.init(title: "Home",rounterName: ""),
    ETCDKVMenuModel.init(title: "Home",rounterName: ""),
    ETCDKVMenuModel.init(title: "Home",rounterName: ""),
]

