//
//  ETCDKeyContentMembersListView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI

struct ETCDKeyContentMembersListView: View {
    
    @State private  var currentTextValue = MemberTextValue()
    @EnvironmentObject var storeObj : ItemStore
    @State private  var isShowingPopover = false
    @State private var currentMember :KVMemberModel = KVMemberModel.getMembers().first!
    
    private func Reaload() {
         storeObj.KVReaload()
     }
    
    var body: some View {
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

struct ETCDKeyContentMembersListView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDKeyContentMembersListView()
    }
}
