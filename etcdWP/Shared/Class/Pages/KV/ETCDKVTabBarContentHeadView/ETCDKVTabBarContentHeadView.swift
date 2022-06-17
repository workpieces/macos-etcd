//
//  ETCDKVTabBarContentHeadView.swift
//  etcdWP
//
//  Created by FaceBook on 2022/5/20.
//

import SwiftUI
import PopupView
import Combine
import FilePicker
import ObjectMapper

struct ETCDKVTabBarContentHeadView: View {
    
   @EnvironmentObject var storeObj : ItemStore
    var body: some View {
        HStack {
            withDefaultNavagationBack(title: "ETCD CLUSTER V3")
                .padding(.vertical,30)
                .padding(.leading ,20)
            
            Button {
                Task{
                    do {
                        try await storeObj.Open()
                    }catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("开启服务")
                    .foregroundColor(Color(hex:"#00FFFF"))
            }
            
            Button {
                do {
                    try storeObj.Close()
                }catch{
                    print(error.localizedDescription)
                }
            } label: {
                Text("关闭服务")
                    .foregroundColor(Color(hex:"#00FFFF"))
            }
            
            FilePicker(types:[.plainText,.text,.json], allowMultiple: true) { urls in
                do {
                    let data = try Data(contentsOf: urls[0])
                    let decoder = JSONDecoder()
                    let outs = try decoder.decode([OutKvModel].self, from: data)
                    for item in outs {
                        let resp = storeObj.Put(key: item.key, value: item.value)
                        if resp?.status != 200 {
                            throw NSError.init(domain: resp?.message ?? "", code: resp?.status ?? 500)
                        }
                    }
                    storeObj.KVReaload(false)
                } catch {
                    print(error.localizedDescription)
                }
            } label: {
                Text("批量导入")
                    .foregroundColor(Color(hex:"#00FFFF"))
            }
            
            // copy from https://www.raywenderlich.com/books/swiftui-apprentice/v1.0/chapters/19-saving-files
            Button {
                do {
                    let path  = showOpenPanel()
                    guard  path?.path.isEmpty != nil else {
                        throw NSError.init(domain: "保存目录不能为空", code: 500)
                    }
                    var outs = [OutKvModel]()
                    for item in storeObj.realeadData.temp {
                        if  !item.key!.isEmpty && !item.value!.isEmpty {
                            let key = item.key ?? ""
                            let value = item.value ?? ""
                            outs.append(OutKvModel.init(key: key, value: value))
                        }
                    }
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    let data = try encoder.encode(outs)
                    let current_url  =  path!.appendingPathComponent("etcdwp.json")
                    try data.write(to: current_url)
                } catch {
                    print(error.localizedDescription)
                }
            } label: {
                Text("批量导出")
                    .foregroundColor(Color(hex:"#00FFFF"))
            }
            .padding(.trailing,15)
        }
    }
}

