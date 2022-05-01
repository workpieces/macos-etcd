//
//  CardItemView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI

struct CardItemView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @State private var showAlert = false
    @State private var pushEdit = false
    @State var  options: EtcdClientOption
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
                    Text("服务名称")
                        .withDefaultContentTitle(fontColor: .white)
                    
                    Text(options.clientName)
                        .withDefaultSubContentTitle(fontColor: .white)
                }
                .padding(DefaultSpacePadding)
            }
            VStack(alignment: .center,spacing: 8.0) {
                Text("节点地址")
                    .withDefaultContentTitle(fontColor: .white)
                
                Text(options.endpoints.first!)
                    .withDefaultSubContentTitle(fontColor: .white)
                
                Spacer()
                
                Text("连接状态")
                    .withDefaultContentTitle(fontColor: .white)
                
                Text(options.status == true ? "Scuess" : "Failed")
                    .withDefaultSubContentTitle(fontColor: options.status == true ? Color(hex:"#7CFC00") : .red)
                Spacer()
                HStack(){
                    Spacer()
                    Button {
                        if options.status == true {
                         try! homeData.CloseUseUUID(uuid: options.id.uuidString)
                        }else{
                            try! homeData.OpenUseUUID(uuid: options.id.uuidString)
                        }
                        options.status.toggle()
                    } label: {
                        Text(options.status == true ? "停止" : "开启")
                            .font(.system(size: 10.0))
                            .foregroundColor(.white)
                            .frame(width: 50)
                    }
                }.padding(10)
            }
        }
        .frame(minHeight: 210, maxHeight: 260)
        .background(Color.init(hex: "#00FFFF").opacity(0.15))
        .cornerRadius(DefaultRadius)
    }
}

