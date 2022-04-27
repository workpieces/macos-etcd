//
//  ETCDKVSubContentView.swift
//  etcdWP
//
//  Created by taoshumin_vendor on 2022/4/25.
//

import SwiftUI

struct MakeMemberPopoverContent: View {
    @Binding var currentModel  : KVMemberModel
    @State var text : String
    @State var isOn : Bool
    var body: some View {
        VStack {
            switch currentModel.type {
            case 0:
                Section(header: Text("创建集群成员").foregroundColor(.white).font(.system(size: 12))) {
                    TextField("节点地址: ",value: $text, formatter: NumberFormatter())
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    Toggle("IsLearner", isOn: $isOn)
                        .foregroundColor(.white)
                        .toggleStyle(.switch)
                }
                .frame(width: 180, alignment: .center)
                .padding(.top,15)
                Spacer()
            case 1:
                Section(header: Text("删除集群成员").foregroundColor(.white).font(.system(size: 12))) {
                    TextField("节点id: ",value: $text, formatter: NumberFormatter())
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                .frame(width: 180, alignment: .center)
                .padding(.top,15)
                Spacer()
            case 2:
                Section(header: Text("更新集群成员").foregroundColor(.white).font(.system(size: 12))) {
                    TextField("修改前节点id: ",value: $text, formatter: NumberFormatter())
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    TextField("修改后节点地址: ",value: $text, formatter: NumberFormatter())
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                .frame(width: 180, alignment: .center)
                .padding(.top,15)
                Spacer()
            case 3:
                Section(header: Text("Promotes集群成员").foregroundColor(.white).font(.system(size: 12))) {
                    TextField("节点id: ",value: $text, formatter: NumberFormatter())
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
                .frame(width: 180, alignment: .center)
                .padding(.top,15)
                Spacer()
            default:
                Section(header: Text("创建集群成员").foregroundColor(.white).font(.system(size: 12))) {
                    TextField("节点地址: ",value: $text, formatter: NumberFormatter())
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    Toggle("IsLearner", isOn: $isOn)
                        .foregroundColor(.white)
                        .toggleStyle(.switch)
                }
                .frame(width: 180, alignment: .center)
                .padding(.top,15)
                Spacer()
            }
            
            HStack {
                Button {
                    
                } label: {
                    Text("取消")
                        .font(.system(size: 11))
                        .foregroundColor(.yellow)
                }
                .padding(.trailing,20)
                
                Button {
                    
                } label: {
                    Text("确定")
                        .font(.system(size: 11))
                        .foregroundColor(.yellow)
                }
            }
            Spacer()
        }
        .frame(width: 280, height: 180)
    }
}

