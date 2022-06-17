//
//  HomeTabarStore.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/27.
//

import SwiftUI

// 左侧Tab选择状态
class HomeTabSelectModel: ObservableObject {
    @Published var selectTab = "Home"
    @Published var etcdTab = "KV"
    
    //获取版本
    func getVersion() ->  String {
        let infoDic = Bundle.main.infoDictionary
        return infoDic?["CFBundleShortVersionString"] as! String
    }
    
}

struct TabbarOption: Hashable {
    let title: String
    let image: String
}

let tabarOption:[TabbarOption] = [
    TabbarOption.init(title: "Home", image: "house"),
    TabbarOption.init(title: "About", image: "info.circle"),
]
