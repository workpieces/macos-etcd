//
//  ETCDDetialHeadView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/31.
//

import SwiftUI
import SwiftUIRouter
import PopupView
struct ETCDDetialHeadView: View {
    @EnvironmentObject var storeObj : ItemStore
    fileprivate func Reaload() {
        Task{
            await  storeObj.KVReaload(false)
        }
    }
    
    fileprivate func DeleteALL() throws {
        defer {
            Task{
                await  storeObj.KVReaload(false)
            }
        }
        let resp = storeObj.DeleteALL()
        if resp?.status != 200 {
            throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
        }
    }
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
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
                        .padding(8)
                        .frame(height: 25)
                }.background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                
                Button {
                    do {
                        try self.DeleteALL()
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Text(LocalizedStringKey("清空键值"))
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(8)
                        .frame(height: 25)
                }.background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                Button {
                    storeObj.showFormat =  storeObj.showFormat == .Tree ? .List:.Tree
                    Task{
                        await  storeObj.KVReaload(true)
                    }
                } label: {
                    Text(LocalizedStringKey(storeObj.showFormat.Name()))
                        .font(.caption)
                        .foregroundColor(Color(hex:"#00FFFF"))
                        .padding(8)
                        .frame(height: 25)
                }.background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                Spacer()
                Menu {
                    ForEach(menuModels) { index in
                        NavLink(to:index.rounterName) {
                            Text(LocalizedStringKey(index.title))
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                    }
                } label: {
                    Text(LocalizedStringKey("键值操作"))
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(8)
                        .frame(maxHeight: 25)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(10)
                        .buttonStyle(.plain)
                }.padding(.trailing ,15)
            }.padding(.all,4.0)
        }
    }
}
