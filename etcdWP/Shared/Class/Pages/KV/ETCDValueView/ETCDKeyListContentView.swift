//
//  ETCDKeyListContentView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI
import NavigationStack
import PopupView
import Combine
import FilePicker
import ObjectMapper

struct ETCDKeyListContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    @State private var currentMember :KVMemberModel = KVMemberModel.getMembers().first!
    @State private  var currentTextValue: MemberTextValue = MemberTextValue.init()
    @State private  var isShowingPopover = false
    @State private var isShowingUpdatePopover = false
    @State private var textValue: String = ""
    @State private var isDefaultSelectType: Int = 0
    func Reaload() {
        storeObj.KVReaload()
    }
    
    func DeleteALL() throws {
        defer {storeObj.KVReaload()}
        let resp = storeObj.DeleteALL()
        if resp?.status != 200 {
            throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
        }
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
    
    fileprivate func headerView() -> some View {
        return VStack{
            HStack{
                Text("服务地址：\(storeObj.c.endpoints.first ?? "127.0.0.1:2379")")
                    .font(.caption)
                    .foregroundColor(.white)
                Spacer()
                
                if storeObj.c.status {
                    Text("链接状态: 正常")
                        .font(.caption)
                        .foregroundColor(.green)
                }else{
                    Text("链接状态: 异常")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .padding(.all,4.0)
            HStack {
                Button {Reaload()} label: {
                    Text("刷新加载")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                Button {
                    do {
                        try self.DeleteALL()
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Text("清空键值")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                
                Button {
                    storeObj.showFormat =  storeObj.showFormat == .Tree ? .List:.Tree
                } label: {
                    Text(storeObj.showFormat.Name())
                        .font(.caption)
                        .foregroundColor(Color(hex:"#00FFFF"))
                }
                
                Spacer()
                Button {} label: {
                    Text("查询")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    
    var body: some View {
        VStack {
            if storeObj.showFormat == .List{
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
                        headerView()
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
            }else{
                VStack(spacing:1){
                    headerView()
                        .padding(10)
                        .padding(.leading,3)
                        .padding(.trailing,3)
                        .frame(height:60)
                        .background(Color(hex: "#221C27"))
                    List(storeObj.Chidren(), children: \.children) { item in
                        ETCDKVItemView(item:item)
                            .onTapGesture(perform: {
                                if item.children == nil{
                                    self.storeObj.realeadData.currentKv = item
                                }
                            })
                            .buttonStyle(PlainButtonStyle())
                            .contextMenu(menuItem(item))
                    }
                    .background(Color(hex: "#221C27"))
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
                                    Spacer()
                                }
                                .frame(width: 280, height: 320)
                            }
                        }
                }
            }
            
            HStack {
                Spacer()
                Text("当前页:  \(storeObj.realeadData.GetCurrentPage())  ")
                    .foregroundColor(.secondary)
                    .font(.caption)
                Spacer()
                Button {
                    storeObj.Last()
                } label: {
                    Text("上一页")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                Spacer()
                Button {
                    storeObj.Next()
                } label: {
                    Text("下一页")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                Spacer()
                Text("总数:  \(storeObj.realeadData.GetKvCount())  ")
                    .foregroundColor(.secondary)
                    .font(.caption)
                Spacer()
            }
            List {
                Section {
                    ForEach(storeObj.realeadData.members) { item in
                        HStack {
                            VStack {
                                Spacer()
                                HStack{
                                    Text("名称： \(item.members?.name ?? "")")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .lineSpacing(8.0)
                                        .truncationMode(.middle)
                                    Spacer()
                                    let mid  = String(item.members?.mid ?? "000000").suffix(6)
                                    Text("ID： \(String(mid))")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .lineSpacing(8.0)
                                        .truncationMode(.middle)
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button("复制成员", action: {
                                                copyToClipBoard(textToCopy: item.members?.mid ?? "")
                                            })
                                            Button("删除成员", action: {
                                                do {
                                                    guard !(item.members?.mid!.isEmpty)! else {
                                                        throw NSError.init(domain: "成员id输入有误", code: 400)
                                                    }
                                                    
                                                    let resp  =  storeObj.MemberRemove(id: (item.members?.mid)!)
                                                    guard resp?.status == 200 else {
                                                        throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
                                                    }
                                                    
                                                    Reaload()
                                                } catch  {
                                                    print(error.localizedDescription)
                                                }
                                            })
                                            Button("提升成员", action: {
                                                do {
                                                    guard !(item.members?.mid!.isEmpty)! else {
                                                        throw NSError.init(domain: "成员id输入有误", code: 400)
                                                    }
                                                    
                                                    let resp = storeObj.MemberPromotes(id: (item.members?.mid)!)
                                                    guard resp?.status == 200 else {
                                                        throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
                                                    }
                                                    
                                                    Reaload()
                                                } catch  {
                                                    print(error.localizedDescription)
                                                }
                                            })
                                        }))
                                    Spacer()
                                    Rectangle()
                                        .foregroundColor(item.members?.status ?? false ? .red : .green)
                                        .frame(width:8.0,height: 8.0)
                                }
                                .padding(.leading,10)
                                .padding(.trailing,10)
                                
                                Divider()
                                
                                VStack(alignment: .leading){
                                    HStack {
                                        Text("节点： \(item.members?.peer_addr ?? "")")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white)
                                            .lineSpacing(8.0)
                                            .truncationMode(.middle)
                                        Spacer()
                                    }
                                    .padding(.leading,10)
                                    .padding(.trailing,10)
                                    
                                    Divider()
                                    HStack {
                                        Text("客户端： \(item.members?.client_addr ?? "")")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white)
                                            .lineSpacing(8.0)
                                            .truncationMode(.middle)
                                        Spacer()
                                    }
                                    .padding(.leading,10)
                                    .padding(.trailing,10)
                                }
                                Divider()
                            }
                        }
                        .background(Color.secondary.opacity(0.25))
                        .cornerRadius(8.0)
                        .shadow(radius: 8.0,x: 0.0,y: 8.0)
                    }
                } header: {
                    VStack {
                        HStack(content: {
                            Text("成员（Members）")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("成员总数:  \(storeObj.realeadData.GetMemberCount()) ")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        })
                        .padding(.all,4.0)
                        
                        // Create Members / Delete Members / Update Members
                        LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 3), alignment: .center) {
                            ForEach(KVMemberModel.getMembers()) { item in
                                Button {
                                    self.currentMember = item
                                    self.isShowingPopover.toggle()
                                } label: {
                                    Text(item.name)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                        }.popover(isPresented: $isShowingPopover,arrowEdge: .trailing) {
                            MakeMemberPopoverContent(currentModel: $currentMember,textVauleModel: $currentTextValue) {
                                defer {self.isShowingPopover.toggle()}
                                
                                guard currentTextValue.isConfirm else {
                                    return
                                }
                                
                                switch currentTextValue.current_type {
                                case 0:
                                    do {
                                        guard !currentTextValue.peerAddress.isEmpty else {
                                            throw NSError.init(domain: "成员地址输入有误", code: 400)
                                        }
                                        let resp = storeObj.MemberAdd(endpoint: currentTextValue.peerAddress, learner: currentTextValue.isLearner)
                                        guard resp?.status == 200 else {
                                            throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
                                        }
                                        Reaload()
                                    } catch  {
                                        print(error.localizedDescription)
                                    }
                                case 1:
                                    do {
                                        guard Int(currentTextValue.update_member_id_old) != 0 && !currentTextValue.update_member_peer_address_new.isEmpty else {
                                            throw NSError.init(domain: "成员地址输入有误", code: 400)
                                        }
                                        
                                        let resp =  storeObj.MemberUpdate(id: currentTextValue.update_member_id_old, peerUrl: currentTextValue.update_member_peer_address_new)
                                        guard resp?.status == 200 else {
                                            throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
                                        }
                                    } catch  {
                                        print(error.localizedDescription)
                                    }
                                case 2:
                                    do {
                                        guard !currentTextValue.promotes_member_id.isEmpty  else {
                                            throw NSError.init(domain: "成员输入有误", code: 400)
                                        }
                                        
                                        let resp = storeObj.MemberPromotes(id: currentTextValue.update_member_id_old)
                                        guard resp?.status == 200 else {
                                            throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
                                        }
                                    } catch  {
                                        print(error.localizedDescription)
                                    }
                                default:
                                    do {
                                        guard !currentTextValue.peerAddress.isEmpty else {
                                            throw NSError.init(domain: "成员地址输入有误", code: 400)
                                        }
                                        let resp = storeObj.MemberAdd(endpoint: currentTextValue.peerAddress, learner: currentTextValue.isLearner)
                                        guard resp?.status == 200 else {
                                            throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
                                        }
                                        Reaload()
                                    } catch  {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
            .frame(minHeight: 180.0, idealHeight: 180.0, maxHeight: 250)
        }
    }
}



struct ETCDKeyListContentView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDKeyListContentView()
    }
}
