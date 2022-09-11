//
//  ETCDViewLeaseListView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/8/1.
//

import SwiftUI
import SwiftUIRouter
let LeaseRouterName = "LeaseList"
struct ETCDViewLeaseListView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject var storeObj : ItemStore
    init() {
           UITextField.appearance().backgroundColor = .clear
       }
    var body: some View {
        GeometryReader { proxy in
            ZStack{
                VStack{
                    HStack{
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                            .onTapGesture {
                                navigator.goBack()
                            }
                        Spacer()
                        Text(LocalizedStringKey("租约管理"))
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                    }.frame(height:proxy.safeAreaInsets.top)
                    ETCDViewLeaseListContentView(items:storeObj.LeaseList()?.datas ?? [])
                }
                
            }
        }
        
    }
}

struct ETCDViewLeaseListContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    @EnvironmentObject private var navigator: Navigator
    @State var items :[KVData]
    @State var isShowToast: Bool = false
    @State var timeText: String = ""
    @State var times :Int = 0
    var body: some View {
        VStack(){
            HStack(){
                Text(LocalizedStringKey("创建租约"))
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.trailing,8)
                    .padding(.leading,10)
                TextField.init("请输入时间", text: $timeText)
                    .textFieldStyle(.roundedBorder)
                    .padding(10)
            }
            HStack{
                Button {
                    
                    guard !timeText.isEmpty else{
                        return
                    }
                    let  numStrin  =  timeText.trimmingCharacters(in: .decimalDigits)
                    if numStrin.isEmpty {
                        let time = Int(timeText)
                        if time == nil {
                            self.isShowToast.toggle()
                            return
                        }
                        self.isShowToast = false
                        if time != times{
                            let  result   =  storeObj.LeaseGrant(ttl:time!)
                            if result?.status != 200 {
                                self.isShowToast.toggle()
                            }else{
                                items =  storeObj.LeaseList()?.datas ?? []
                                //                                presentationMode.wrappedValue.dismiss()
                                self.isShowToast = false
                            }
                        }
                    }
                    
                    // presentationMode.wrappedValue.dismiss()  todo 丢弃
                } label: {
                    Text("确定")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }.padding(6)
                Text("").frame(width: 40)
                Button {
                    let  _ =  navigator.goBack()
                } label: {
                    Text("关闭")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }.padding(10)
            }
            ETCDADBannerTipView()
                .frame( height:44)
            if #available(iOS 15.0, *) {
                leaseListView.listRowSeparator(.hidden)
            } else {
                leaseListView
            }
            if items.count >= 5 {
                ETCDADBannerTipView()
                    .frame( height:44)
                Text("").frame(height: 0)
            }
        }
        .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 2) {
            TopToastView(title:"操作租约错误")
        }
        
    }
}

//方法
extension ETCDViewLeaseListContentView {
    
    func deleFunc(item:KVData) {
        let reuslt = storeObj.LeaseRevoke(leaseid: String(item.ttlid!))
        items =  storeObj.LeaseList()?.datas ?? []
        if reuslt?.status != 200 && reuslt != nil {
            self.isShowToast.toggle()
        }else{
            self.isShowToast = false;
        }
    }
    
    func LiveOnceFunction(item:KVData) {
        let reuslt = storeObj.keepAliveOnce(leaseid: Int(item.ttlid!))
        if reuslt?.status != 200 && reuslt != nil {
            self.isShowToast.toggle()
        }else{
            self.isShowToast = false;
        }
    }
    
    
}


//列表
extension ETCDViewLeaseListContentView {
    
    private var leaseListView : some View {
        List(items.reversed()){ item in
            HStack(){
                Text(String(format: "ID：%ld", item.ttlid!))
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
            }.listRowBackground(Color.black.opacity(0.2).ignoresSafeArea())
        }.listStyle(.plain)
            .buttonStyle(.plain)
        
    }
    
}
