//
//  ETCDEtcdOperationView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/30.
//

import Foundation
import SwiftUI

struct ETCDEtcdOperationView :View {
    @EnvironmentObject var storeObj : ItemStore
    @State var show: Bool = false
    @State var currentModel :KVOperateModel = KVOperateModel.getItems().first!
    @State var type :Int = 0
    @State var isEnable :Bool = false

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
                            if item.type == 5 {
                                ETCDCheckBoxView(IsChoice: $isEnable) { newValue in
                                    let _ =  storeObj.authEnable(enble: newValue)
                                    print("--------\(newValue)")
                                }
                            }
                            Spacer()
                        }

                        Spacer()
                    }.onTapGesture {
                        self.currentModel = item
                        self.type = self.currentModel.type
                        self.show.toggle()
                    }
                    .background(Color.secondary.opacity(0.15))
                    .cornerRadius(8)
                    .clipped()
                }
            }
            .padding(8.0)
            
        }.sheet(isPresented: $show, onDismiss: didDismiss) {
           ETCDSheetView(currentModel: $currentModel)
        }
    }
    
    func didDismiss() {
        //消失回调
        storeObj.KVReaload()
    }
}

