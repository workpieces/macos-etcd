//
//  AboutModel.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/24.
//

import Foundation

struct AboutModel : Identifiable,Hashable {
    var id = UUID()
    var title: String
    var desc: String
    var status: Int  // 0: 不显示 1：已发布 2： 研发中
    var logo: String
    var link: String
}

let abouts: [AboutModel] = [
    AboutModel(
        title: "Workpieces Websit",
        desc: "Workpieces LLC 官网",
        status: 0,
        logo: "",
        link: "https://workpieces.github.io/workpieces_websit"),
    AboutModel(
        title: "Github",
        desc: "Workpieces 官方开发社区和组织仓库",
        status: 0,
        logo: "",
        link: "https://github.com/workpieces"),
    AboutModel(
        title: "推荐 MediaGB",
        desc: "MediaGB是一个基于GB28181标准实现的网络视频平台，支持NAT穿透，支持海康、大华、宇视等品牌的IPC、NVR、DVR接入。支持rtsp/rtmp等视频推流、流转发到国标平台。",
        status: 2,
        logo: "",
        link: "https://github.com/workpieces"),
]
