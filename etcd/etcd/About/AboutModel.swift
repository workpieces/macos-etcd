//
//  AboutModel.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/24.
//

import Foundation

struct AboutModel: Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var desc: String
    var link: String
}

let abouts: [AboutModel] = [
    AboutModel(image: "3744_list", title: "使用文档", desc: "如何使用",link: "https://github.com/workpieces/Karma/wiki"),
    AboutModel(image: "3744_list", title: "Github地址", desc: "可以提issus或者意见",link: "https://github.com/workpieces/Karma"),
]
