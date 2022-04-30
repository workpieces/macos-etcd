//
//  DeletingLeaseListView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/29.
//

import SwiftUI

struct DeletingLeaseListView: View {
    @State var items :[KVData]
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    @State var isSucceFul: Bool = false
    @State var timeText: String = ""
    @State var times :Int = 0
    @Binding var currentModel  : KVOperateModel
    @Environment(\.presentationMode) var presentationMode
    
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
        VStack(){
            Text(currentModel.name)
                .padding(.top,10)
                .padding(.trailing,10)
                .padding(.leading,10)
                .padding(.bottom,5)
            HStack(){
                TextField.init("请输入时间", text: $timeText)
                    .textFieldStyle(.roundedBorder)
                    .padding(10)
                Button {
                    let  numStrin  =  timeText.trimmingCharacters(in: .decimalDigits)
                    if numStrin.isEmpty {
                        let time = Int(timeText)
                        if time != times{
                            let  result   =  storeObj.LeaseGrant(ttl:time!)
                            if result?.status != 200 {
                                self.isSucceFul.toggle()
                                self.isShowToast.toggle()
                            }else{
                                items =  storeObj.LeaseList()?.datas ?? []
                            }
                        }
                    }
                } label: {
                    Text("确定")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(10)
                }
            }
            leaseListView
        }
        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
         .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
            TopToastView(title:self.isSucceFul ? "移除租约成功":"移除租约错误")
           }

    }
}



extension DeletingLeaseListView {
    
    private var leaseListView : some View {
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
                        Button("移除", action: {
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
                    Text("移除")
                        .font(.system(size: 10.0))
                        .foregroundColor(.yellow)
                }
            }
        }
        
    }
    
}
