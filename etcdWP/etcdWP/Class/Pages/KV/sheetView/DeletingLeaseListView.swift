//
//  DeletingLeaseListView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/29.
//

import SwiftUI

struct DeletingLeaseListView: View {
    var items :[KVData]
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    @State var isSucceFul: Bool = false
    
    fileprivate func deleFunc(item:KVData) {
        let reuslt = storeObj.LeaseRevoke(leaseid: Int(item.ttlid!))
        if reuslt?.status != 200{
            self.isShowToast.toggle()
        }else{
            self.isSucceFul .toggle()
            self.isShowToast.toggle()
        }
    }
    
    var body: some View {
        List(items){ item in
            HStack(){
                Text(String(format: "租约ID：%ld", item.ttlid!))
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .opacity(0.75)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("粘贴", action: {
                            copyToClipBoard(textToCopy:String(format:"%ld", item.ttlid!))
                        })
                        Button("删除", action: {
                            deleFunc(item: item)
                        })
                    }))
                Spacer()
                Button {
                    copyToClipBoard(textToCopy:String(format:"%ld", item.ttlid!) )
                } label: {
                    Text("粘贴")
                        .font(.system(size: 10.0))
                        .foregroundColor(.yellow)
                }
                Button {
                    deleFunc(item: item)
                } label: {
                    Text("删除")
                        .font(.system(size: 10.0))
                        .foregroundColor(.yellow)
                }
            }
        }.popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
            TopToastView(title:self.isSucceFul ? "移除租约成功":"移除租约错误")
           }

    }
}
