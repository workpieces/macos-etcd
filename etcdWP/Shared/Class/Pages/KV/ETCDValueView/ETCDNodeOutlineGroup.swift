//
//  ETCDNodeOutlineGroup.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI

struct ETCDNodeOutlineGroup: View {
    
    @EnvironmentObject var storeObj : ItemStore
    var callback:(_ newValue: Bool,_ index:Int,_ text:String) -> Void
    let node: KVData
    let childKeyPath: KeyPath<KVData, [KVData]?>
    @State fileprivate var isShowingUpdatePopover = false
    @State fileprivate var textValue: String = ""
    @State fileprivate var isDefaultSelectType: Int = 0
    fileprivate func Reaload() {
        storeObj.KVReaload(false)
    }
    
    fileprivate func menuItem(_ item: KVData) -> ContextMenu<TupleView<(Button<Text>, Button<Text>, Button<Text>, Button<Text>, Button<Text>)>> {
        return ContextMenu(menuItems: {
            Button("查看键值详情", action: {
                self.isDefaultSelectType = 1
                storeObj.realeadData.currentKv = item
                self.isShowingUpdatePopover.toggle()
                callback(self.isShowingUpdatePopover,self.isDefaultSelectType,"")
            })
            Button("复制key值", action: {
                copyToClipBoard(textToCopy: item.sep_key ?? "")
            })
            Button("复制value值", action: {
                copyToClipBoard(textToCopy: item.value ?? "")
            })
            Button("删除键值", action: {
                do {
                    let resp = storeObj.Delete(key: item.sep_key!)
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
                storeObj.realeadData.currentKv = item
                self.textValue = item.value ?? ""
                self.isShowingUpdatePopover.toggle()
                callback(self.isShowingUpdatePopover,self.isDefaultSelectType,self.textValue)
            })
        })
    }
    @State var isExpanded: Bool = true
    var body: some View {
        if node[keyPath: childKeyPath] != nil {
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    if isExpanded {
                        ForEach(node[keyPath: childKeyPath]!) { childNode in
                            ETCDNodeOutlineGroup(callback:callback, node: childNode, childKeyPath:childKeyPath,isExpanded:isExpanded)
                        }
                    }
                },
                label: {
                    ETCDNodeOutlineKVItemView(item: node)
                        .padding(.trailing ,8)
                        .onTapGesture(perform: {
                            self.storeObj.realeadData.currentKv = node
                        })
                        .buttonStyle(PlainButtonStyle())
                        .contextMenu( node.children == nil ? menuItem(node):nil)
                }
            ).padding(.leading,10)
        } else {
            ETCDNodeOutlineKVItemView(item: node)
                .onTapGesture(perform: {
                    self.storeObj.realeadData.currentKv = node
                })
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing ,8)
                .contextMenu(node.children == nil ? menuItem(node):nil)
        }
    }
}
