//
//  ETCDKVSubContentView.swift
//  etcdWP
//
//  Created by taoshumin_vendor on 2022/4/25.
//

import SwiftUI

enum Members {
    case Create
    case Delete
    case Update
    case Promote
}

struct MembersConfig {
    var member_id: Int
    var peer_urls: String
    var is_learner : Bool = false
    
    init() {
        self.is_learner = false
        self.peer_urls = ""
        self.member_id = 0
    }
}

struct MakeMemberPopoverContent: View {
    @Binding var memberConfig: MembersConfig
    var body: some View {
        VStack {
            Section(header: Text("创建集群成员").foregroundColor(.secondary).font(.system(size: 16))) {
                TextField("PeerURLs: ",value:$memberConfig.peer_urls, formatter: NumberFormatter())
                Toggle("IsLearner", isOn: $memberConfig.is_learner)
                    .foregroundColor(.secondary)
                    .toggleStyle(.switch)
                    .padding(.top,8.0)
            }
            .frame(width: 180, alignment: .center)
            .padding(.top,15)
            Spacer()
            
            HStack {
                Button {
                    
                } label: {
                    Text("取消")
                        .font(.system(size: 12))
                        .foregroundColor(.red.opacity(0.75))
                }
                
                Button {
                    
                } label: {
                    Text("确定")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex:"#00FFFF").opacity(0.75))
                }
            }
            Spacer()
        }
        .frame(width: 350, height: 200)
    }
}

