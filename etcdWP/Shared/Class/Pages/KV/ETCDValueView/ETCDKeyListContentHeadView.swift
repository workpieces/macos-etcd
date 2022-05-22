//
//  ETCDKeyListContentHeadView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI

struct ETCDKeyListContentHeadView: View {
    
    @EnvironmentObject var storeObj : ItemStore
    fileprivate func Reaload() {
         storeObj.KVReaload()
     }
    
    fileprivate func DeleteALL() throws {
        defer {storeObj.KVReaload()}
        let resp = storeObj.DeleteALL()
        if resp?.status != 200 {
            throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
        }
    }
    
    var body: some View {
        VStack{
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
                    Text(LocalizedStringKey(storeObj.showFormat.Name()))
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
}
