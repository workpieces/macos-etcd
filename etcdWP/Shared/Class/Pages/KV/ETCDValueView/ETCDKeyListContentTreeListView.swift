//
//  ETCDKeyListContentTreeListView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI

struct ETCDKeyListContentTreeListView: View {
    
    @EnvironmentObject var storeObj : ItemStore
    @State fileprivate var isDefaultSelectType: Int = 0
    @State fileprivate var isShowingUpdatePopover = false
    @State fileprivate var textValue: String = ""
    @State var treeModel :KVData?
    fileprivate func Reaload() {
        Task{
            await  storeObj.KVReaload(false)
            treeModel = try?  await storeObj.treeItem()
        }
    }
    
    var body: some View {
        VStack(spacing:1){
            ETCDKeyListContentHeadView()
                .padding(10)
                .padding(.leading,3)
                .padding(.trailing,3)
                .frame(height:60)
                .background(Color(hex: "#221C27"))
            Divider().background(Color.white.opacity(0.15))
            if ((treeModel?.children?.isEmpty) != nil) {
                ETCDNodeOutlineGroup( callback: { newValue, index , text in
                    if !text.isEmpty {
                        self.textValue = text
                    }
                    
                    self.isShowingUpdatePopover = newValue
                    self.isDefaultSelectType = index
                    
                },node: treeModel!, childKeyPath:  \.children)
            }else{
                EmptyView()
            }
            
            Spacer()
        }.background(Color(hex: "#221C27"))
            .onAppear{
                Task{
                    treeModel = try?  await storeObj.treeItem()
                }
            }
            .popover(isPresented: $isShowingUpdatePopover,arrowEdge: .trailing) {
                switch isDefaultSelectType {
                case 0:
                    VStack {
                        Section(header: Text("更新键值").foregroundColor(.white).font(.system(size: 12))) {
                            TextEditor(text: $textValue)
                                .foregroundColor(Color.white)
                                .font(.system(size: 12))
                                .lineSpacing(1.5)
                                .disableAutocorrection(true)
                                .allowsTightening(true)
                                .padding(.bottom,5)
                                .padding(10)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(10)
                                .clipped()
                        }
                        .frame(width: 180, alignment: .center)
                        .padding(.top,15)
                        
                        Spacer()
                        
                        HStack {
                            Button {
                                isShowingUpdatePopover.toggle()
                            } label: {
                                Text("取消")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            .padding(.trailing,20)
                            
                            Button {
                                defer {isShowingUpdatePopover.toggle()}
                                
                                do {
                                    guard !textValue.isEmpty else {
                                        throw NSError.init(domain: "键值不能输入为空", code: 400)
                                    }
                                    let resp =  self.storeObj.Put(key: (self.storeObj.realeadData.currentKv?.sep_key)!, value: textValue)
                                    if resp?.status != 200 {
                                        throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
                                    }
                                    self.storeObj.realeadData.currentKv?.value = textValue
                                    Reaload()
                                } catch  {
                                    print(error.localizedDescription)
                                }
                                
                            } label: {
                                Text("确定")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.bottom,20)
                        Spacer()
                    }
                    .frame(width: 280, height: 320)
                case 1:
                    VStack {
                        Spacer()
                        Section(header: Text("查看键值详情").foregroundColor(.white).font(.system(size: 12))) {
                            Text("CreateRevision： \(String(describing: storeObj.realeadData.currentKv?.create_revision ?? 0))")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("ModRevision： \(String(describing: storeObj.realeadData.currentKv?.mod_revision ?? 0))")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("Version： \(String(describing: storeObj.realeadData.currentKv?.version ?? 0))")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Text("Lease： \(String(describing: storeObj.realeadData.currentKv?.lease ?? 0))")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.top,15)
                        Spacer()
                    }
                    .frame(width: 180, height: 210)
                default:
                    VStack {
                        Section(header: Text("更新键值").foregroundColor(.white).font(.system(size: 12))) {
                            TextEditor(text: $textValue)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                        .frame(width: 180, alignment: .center)
                        .padding(.top,15)
                        
                        Spacer()
                        
                        HStack {
                            Button {
                                isShowingUpdatePopover.toggle()
                            } label: {
                                Text("取消")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                            .padding(.trailing,20)
                            
                            Button {
                                defer {isShowingUpdatePopover.toggle()}
                                
                                do {
                                    guard !textValue.isEmpty else {
                                        throw NSError.init(domain: "键值不能输入为空", code: 400)
                                    }
                                    let resp =  self.storeObj.Put(key: (self.storeObj.realeadData.currentKv?.sep_key)!, value: textValue)
                                    if resp?.status != 200 {
                                        throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
                                    }
                                    Reaload()
                                } catch  {
                                    print(error.localizedDescription)
                                }
                            } label: {
                                Text("确定")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }
                    .frame(width: 280, height: 320)
                }
            }
    }
}

