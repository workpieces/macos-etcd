//
//  ETCDKeyListContentListView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI

struct ETCDKeyListContentListView: View {
    @EnvironmentObject var storeObj : ItemStore
    @State fileprivate var isShowingUpdatePopover = false
    @State fileprivate var textValue: String = ""
    @State fileprivate var isDefaultSelectType: Int = 0
    
    fileprivate func Reaload() {
         storeObj.KVReaload()
     }
    
    fileprivate func menuItem(_ item: KVData) -> ContextMenu<TupleView<(Button<Text>, Button<Text>, Button<Text>, Button<Text>, Button<Text>)>> {
        return ContextMenu(menuItems: {
            Button("查看键值详情", action: {
                self.isDefaultSelectType = 1
                self.storeObj.realeadData.currentKv = item
                self.isShowingUpdatePopover.toggle()
            })
            Button("复制key值", action: {
                copyToClipBoard(textToCopy: item.key ?? "")
            })
            Button("复制value值", action: {
                copyToClipBoard(textToCopy: item.value ?? "")
            })
            Button("删除键值", action: {
                do {
                    let resp = storeObj.Delete(key: item.key!)
                    if resp?.status != 200 {
                        throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
                    }
                    Reaload()
                } catch  {
                    print(error.localizedDescription)
                }
            })
            Button("更新键值", action: {
                self.isDefaultSelectType = 0
                self.storeObj.realeadData.currentKv = item
                self.textValue = item.value ?? ""
                self.isShowingUpdatePopover.toggle()
            })
        })
    }
    
    
    var body: some View {
        List {
            Section {
                ForEach(storeObj.realeadData.kvs) { item in
                    ETCDKVItemView(item: item)
                        .onTapGesture(perform: {
                            self.storeObj.realeadData.currentKv = item
                        })
                        .contextMenu(menuItem(item))
                        .buttonStyle(PlainButtonStyle())
                }
                
            } header: {
                ETCDKeyListContentHeadView(storeObj: storeObj)
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
                            Text("Cancle")
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
                                let resp =  self.storeObj.Put(key: self.storeObj.realeadData.GetKey(), value: textValue)
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
                                let resp =  self.storeObj.Put(key: self.storeObj.realeadData.GetKey(), value: textValue)
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
                    .padding(.bottom,20)
                    Spacer()
                }
                .frame(width: 280, height: 320)
            }
        }
        .listRowInsets(nil)
        .listStyle(.inset)
    }
}
