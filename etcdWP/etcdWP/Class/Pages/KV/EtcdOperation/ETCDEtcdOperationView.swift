//
//  ETCDEtcdOperationView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/30.
//

import Foundation
import SwiftUI

struct ETCDEtcdOperationView :View {
    @State var show: Bool = false
    @State var currentModel :KVOperateModel = KVOperateModel.getItems().first!
    @EnvironmentObject var storeObj : ItemStore
    var body: some View {
        ZStack(alignment: .topLeading){
            List {
                ForEach(KVOperateModel.getItems()) { item in
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(item.name)
                                .font(.body)
                                .foregroundColor(.white)
                                .truncationMode(.middle)
                                .frame(maxHeight: 44.0)
                            Text(item.english)
                                .font(.body)
                                .foregroundColor(.white)
                                .truncationMode(.middle)
                                .frame(maxHeight: 44.0)
                            Spacer()
                        }
                        Spacer()
                    }.onTapGesture {
                        self.currentModel = item
                        self.show.toggle()
                    }
                    .background(Color.secondary.opacity(0.15))
                    .cornerRadius(8)
                    .clipped()
                }
            }
            .padding(8.0)
            
        }.sheet(isPresented: $show, onDismiss: didDismiss) {
            switch self.currentModel.type {
               case 0 :
                ETCDKeyValueActionsView(currentModel: $currentModel)
                
               default :
                ETCDSheetView(currentModel:$currentModel, text:storeObj.realeadData.currentKv?.value ?? "")
            }
        }
    }
    
    func didDismiss() {
        //消失回调
        storeObj.KVReaload()
    }
}

