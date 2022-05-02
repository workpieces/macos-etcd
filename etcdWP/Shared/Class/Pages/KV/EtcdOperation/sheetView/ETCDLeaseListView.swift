//
//  DeletingLeaseListView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/29.
//

import SwiftUI

struct ETCDLeaseListView: View {
    @State var items :[KVData]
    @EnvironmentObject var storeObj : ItemStore
    @State var isShowToast: Bool = false
    @State var timeText: String = ""
    @State var times :Int = 0
    @Binding var currentModel  : KVOperateModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(){
            Text(currentModel.name)
                .padding(.top,10)
                .padding(.trailing,10)
                .padding(.leading,10)
                .padding(.bottom,5)
            HStack(){
                Text("创建租约")
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.trailing,8)
                    .padding(.leading,10)
                TextField.init("请输入时间", text: $timeText)
                    .textFieldStyle(.roundedBorder)
                    .padding(10)
                Button {
                    
                    guard !timeText.isEmpty else{
                        return
                    }
                    let  numStrin  =  timeText.trimmingCharacters(in: .decimalDigits)
                    if numStrin.isEmpty {
                        let time = Int(timeText)
                        if time != times{
                            let  result   =  storeObj.LeaseGrant(ttl:time!)
                            if result?.status != 200 {
                                self.isShowToast.toggle()
                            }else{
                                items =  storeObj.LeaseList()?.datas ?? []
//                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    
                    // presentationMode.wrappedValue.dismiss()  todo 丢弃
                } label: {
                    Text("确定")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }.padding(6)
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("关闭")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }.padding(10)
                
            }
            leaseListView
        }
        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
            TopToastView(title:"操作租约错误")
        }
        
    }
}


//方法
extension ETCDLeaseListView {
    
    func deleFunc(item:KVData) {
        let reuslt = storeObj.LeaseRevoke(leaseid: String(item.ttlid!))
        if reuslt?.status != 200{
            self.isShowToast.toggle()
        }
    }
    
    func LiveOnceFunction(item:KVData) {
        let reuslt = storeObj.keepAliveOnce(leaseid: Int(item.ttlid!))
        if reuslt?.status != 200{
            self.isShowToast.toggle()
        }
    }
    
    
}


//列表
extension ETCDLeaseListView {
    
    private var leaseListView : some View {
        
        List(items.reversed()){ item in
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
                        Button("存活一次", action: {
                            LiveOnceFunction(item: item)
                        })
                    }))
                Spacer()
                Button {
                    copyToClipBoard(textToCopy:String(format:"%ld", item.ttlid!) )
                } label: {
                    Text("粘贴")
                        .font(.system(size: 10.0))
                        .foregroundColor(.white)
                }
                Button {
                    deleFunc(item: item)
                } label: {
                    Text("移除")
                        .font(.system(size: 10.0))
                        .foregroundColor(.white)
                }
                Button {
                    LiveOnceFunction(item: item)
                } label: {
                    Text("存活一次")
                        .font(.system(size: 10.0))
                        .foregroundColor(.white)
                }
            }
        }
        
    }
    
}
