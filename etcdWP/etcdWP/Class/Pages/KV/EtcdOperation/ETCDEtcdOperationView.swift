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
    @State var isShowToast :Bool  = false
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
                                ETCDCheckBoxView(IsChoice: $isEnable) {  newValue in
                                    let keyValue =  storeObj.authEnable(enble: newValue)
                                    if keyValue?.status != 200{
                                        self.isShowToast.toggle()
                                    }
                                }
                            }
                            Spacer()
                        }

                        Spacer()
                    }.onTapGesture {
                        self.currentModel = item
                        if item.type != 5{
                            self.type = self.currentModel.type
                            self.show.toggle()
                        }
                    }
                    .background(Color.secondary.opacity(0.15))
                    .cornerRadius(8)
                    .clipped()
                }
            }
            .padding(8.0)
            
        }.sheet(isPresented: $show, onDismiss: didDismiss) {
           ETCDSheetView(currentModel: $currentModel)
        }.popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
            TopToastView(title:"开启认证失败")
        }
    }
    
    func didDismiss() {
        //消失回调
        storeObj.KVReaload()
    }
}

