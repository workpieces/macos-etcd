//
//  CardItemView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI
import Alamofire

struct CardItemView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @State private var showAlert = false
    @State private var pushEdit = false
    @State  var options: EtcdClientOption
    @Binding var selectedItems: [EtcdClientOption]
    var idx : Int
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button {
                    self.showAlert.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .withDefaultImage(width: 18.0)
                }
                .frame(width: 20, height: 20, alignment: .leading)
                .padding(.vertical,DefaultSpacePadding)
                .padding(.horizontal,DefaultSpacePadding)
                .contentShape(Rectangle())
                .buttonStyle(PlainButtonStyle())
                .onTapGesture {
                    self.showAlert.toggle()
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Want to modify etcd service data?"),
                        message: Text("The connection to the server was lost."),
                        primaryButton: .default(
                            Text("Delete"),
                            action: {
                                self.homeData.Delete(id:self.homeData.GetUUID(idx: idx))
                            }
                        ),
                        secondaryButton: .destructive(
                            Text("Cancle"),
                            action: {
                             
                            }
                        )
                    )
                }
                
                Spacer()
                VStack(spacing: 8.0){
                    HStack(alignment: .center, spacing: 10){
                        Text("服务名称")
                            .withDefaultContentTitle(fontColor: .white)
                        if (selectedItems.count != 0) {
                            Toggle("", isOn: $selectedItems[selectedItems.firstIndex(of: options) ?? 0].checked)
                                .toggleStyle(.checkbox)
                                .padding(.bottom,3)
                                .onChange(of:options.checked) { newValue in
                                    options.checked = newValue
                                }
                        }else{
                            Toggle("", isOn: $options.checked)
                                .toggleStyle(.checkbox)
                                .padding(.bottom,3)
                                .onChange(of:options.checked) { newValue in
                                    options.checked = newValue
                                }
                        }

                    }
                    Text(options.clientName)
                        .withDefaultSubContentTitle(fontColor: .white)
                }
                .padding(DefaultSpacePadding)
            }
            VStack(alignment: .center,spacing: 8.0) {
                Text("节点地址")
                    .withDefaultContentTitle(fontColor: .white)
                    .padding(.bottom,5)
                VStack(alignment: .center){
                    ForEach(options.getEndpoints(),id: \.self) { item in
                        Text(item)
                            .withDefaultSubContentTitle(fontColor: .white)
                            .padding(.leading,5)
                            .padding(.trailing,5)
                            .padding(.horizontal)
                    }
                }.frame( height:50)
                .padding(.bottom,10)
                Text("连接状态")
                    .withDefaultContentTitle(fontColor: .white)
                
                Text(LocalizedStringKey(options.status == true ? "Scuess" : "Failed"))
                    .withDefaultSubContentTitle(fontColor: options.status == true ? Color(hex:"#7CFC00") : .red)
                Spacer()
            }
        }
        .frame( height: 220)
        .background(Color.init(hex: "#00FFFF").opacity(0.15))
        .cornerRadius(DefaultRadius)
        .onAppear{
            print("-----------\(options.checked)")
        }
    }
}

