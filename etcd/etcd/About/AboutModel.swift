//
//  AboutModel.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/24.
//

import Foundation

enum AboutType {
    case Contact
    case Download
    case Documentation
    case Empty
}

struct AboutModel : Identifiable,Hashable {
    var id = UUID()
    var image: String
    var title: String
    var desc: String
    var link: String
    var type: AboutType = .Empty
}

let abouts: [AboutModel] = [
    AboutModel(
        image: "github",
        title: "Contact Us",
        desc: "If you have feature requests, custom app requirements or bugs, contact us :",
        link: "https://github.com/workpieces",
        type: .Contact),
    AboutModel(
        image: "questionmark.circle",
        title: "Download",
        desc: "App for Mac,Window and Linux",
        link: "https://github.com/workpieces/etcdWp",
        type: .Download),
    AboutModel(
        image: "questionmark.circle",
        title: "Documentation",
        desc: "Learn more about etcdWp features and turorials.",
        link: "https://github.com/workpieces/etcdWp/wiki",
        type: .Documentation),
]

let advertise: [AboutModel] = [
    AboutModel(
        image: "",
        title: "Karma",
        desc: "",
        link: "")
]

