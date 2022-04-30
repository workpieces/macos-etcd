//
//  ETCDSheetView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/25.
//

import SwiftUI

struct ETCDSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var storeObj : ItemStore
    @Binding var currentModel  : KVOperateModel
    var body: some View {
        switch self.currentModel.type {
        case 0 ,1:
            ETCDKeyValueActionsView(currentModel: $currentModel)
        case 2:
            ETCDLeaseListView(items: storeObj.LeaseList()?.datas ?? [],currentModel:$currentModel)
        default :
          Text("dsafdasf")
        }
    }
}


