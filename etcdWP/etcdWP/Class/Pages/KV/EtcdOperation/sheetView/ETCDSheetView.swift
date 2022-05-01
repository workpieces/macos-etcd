//
//  ETCDSheetView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/25.
//

import SwiftUI

struct ETCDSheetView: View {
    @EnvironmentObject var storeObj : ItemStore
    @Binding var currentModel  : KVOperateModel
    var body: some View {
        switch self.currentModel.type {
        case 0:
            ETCDKeyValueActionsView(currentModel: $currentModel)
        case 1:
            ETCDKeyPrefixView(currentModel: $currentModel)
        case 2:
            ETCDLeaseListView(items: storeObj.LeaseList()?.datas ?? [],currentModel:$currentModel)
        case 3:
            ETCDRolesListView(items: storeObj.RolesList() ?? [], currentModel: $currentModel)
        case 4:

            ETCDUserListView(items: storeObj.UsersList() ?? [], currentModel: $currentModel)
        default :
          Text("dsafdasf")
        }
    }
}


