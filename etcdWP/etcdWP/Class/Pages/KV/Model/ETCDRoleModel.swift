//
//  ETCDRoleModel.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/30.
//

import Foundation

struct ETCDRoleDetailModel: Codable,Identifiable {
    var id = UUID()
    let role: String?
    let omitempty: String?
    var user: String?
}


struct ETCDRoleModel:  Codable, Identifiable  {
    
    let datas: [ETCDRoleDetailModel]?
    var id = UUID()
    let status: Int?
    // message is response data message.
    // ok or error message
    let message: String?
    // operate
    let operate: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case operate
        case datas
    }
}
