//
//  DeletingLeaseListView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/29.
//

import SwiftUI

struct DeletingLeaseListView: View {
    var items :[KVData]
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
                    
                } label: {
                    Text("删除")
                        .font(.system(size: 10.0))
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}
