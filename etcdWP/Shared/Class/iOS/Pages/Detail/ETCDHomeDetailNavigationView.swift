//
//  ETCDHomeDetailNavigationView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/31.
//

import SwiftUI
import SwiftUIRouter
import FilePicker

struct ETCDHomeDetailNavigationView: View {
    let title:String
    @EnvironmentObject var storeObj : ItemStore
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .center){
                Button {
                    navigator.goBack()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.white)
                        .frame(width: 18,height: 18)
                        .padding(.leading,15)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                Text(LocalizedStringKey(title))
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(height: 40.0, alignment: .leading)
                    .lineLimit(1)
                Spacer()
                Menu {
                    Button(action: {
                        Task{
                            do {
                                try await storeObj.Open()
                            }catch let error as NSError {
                                print(error.localizedDescription)
                            }
                        }
                    }) {
                        Text("开启服务")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                    }
                    Button(action: {
                        do {
                            try storeObj.Close()
                        }catch{
                            print(error.localizedDescription)
                        }
                    }) {
                        Text("关闭服务")
                            .font(.title)
                            .fontWeight(.semibold)
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
                            Task{
                                await   storeObj.KVReaload(false)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    } label: {
                        Text("批量导入")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    Button(action: {
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
                    }) {
                        Text("批量导出")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                } label: {
                    Text(LocalizedStringKey("Services"))
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(5)
                        .frame(maxHeight: 25)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(5)
                        .buttonStyle(.plain)
                }.padding(.trailing ,15)
                
                
            }.frame(width:proxy.size.width,height: UIDevice.isPad() ?  proxy.safeAreaInsets.top + 44 : proxy.safeAreaInsets.top)
            
        }
    }
}

