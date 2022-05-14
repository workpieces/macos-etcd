//
//  ETCDKVSubContentView.swift
//  etcdWP
//
//  Created by taoshumin_vendor on 2022/4/25.
//

import SwiftUI

struct MemberTextValue {
    var peerAddress: String = ""
    var isLearner : Bool = false
    var delete_member_id: String = ""
    var update_member_id_old : String = ""
    var update_member_peer_address_new : String = ""
    var promotes_member_id : String = ""
    var current_type : Int = 0
    var isConfirm : Bool = false
}

struct MakeMemberPopoverContent: View {
    @Binding var currentModel  : KVMemberModel
    @Binding var textVauleModel: MemberTextValue
    var action: (() -> Void)?
    var body: some View {
        VStack {
            switch currentModel.type {
            case 0:
                Section(header: Text("创建集群成员").foregroundColor(.white).font(.system(size: 12))) {
                    TextField("节点地址: ",value: $textVauleModel.peerAddress, formatter: NumberFormatter())
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    Toggle("IsLearner", isOn: $textVauleModel.isLearner)
                        .foregroundColor(.white)
                        .toggleStyle(.switch)
                }
                .frame(width: 180, alignment: .center)
                .padding(.top,15)
                Spacer()
            case 1:
                Section(header: Text("更新集群成员").foregroundColor(.white).font(.system(size: 12))) {
                    TextField("修改前节点id: ",value: $textVauleModel.update_member_id_old, formatter: NumberFormatter())
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    TextField("修改后节点地址: ",value: $textVauleModel.update_member_peer_address_new, formatter: NumberFormatter())
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                .frame(width: 180, alignment: .center)
                .padding(.top,15)
                Spacer()
            case 2:
                Section(header: Text("Promotes集群成员").foregroundColor(.white).font(.system(size: 12))) {
                    TextField("节点id: ",value: $textVauleModel.promotes_member_id, formatter: NumberFormatter())
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                .frame(width: 180, alignment: .center)
                .padding(.top,15)
                Spacer()
            default:
                Section(header: Text("创建集群成员").foregroundColor(.white).font(.system(size: 12))) {
                    TextField("节点地址: ",value: $textVauleModel.peerAddress, formatter: NumberFormatter())
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    Toggle("IsLearner", isOn: $textVauleModel.isLearner)
                        .foregroundColor(.white)
                        .toggleStyle(.switch)
                }
                .frame(width: 180, alignment: .center)
                .padding(.top,15)
                Spacer()
            }
            
            HStack {
                Button {
                    textVauleModel.current_type = currentModel.type
                    textVauleModel.isConfirm = false
                    action!()
                } label: {
                    Text("取消")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                .padding(.trailing,20)
                
                Button {
                    textVauleModel.current_type = currentModel.type
                    textVauleModel.isConfirm = true
                    action!()
                } label: {
                    Text("确定")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        .frame(width: 280, height: 180)
    }
}
