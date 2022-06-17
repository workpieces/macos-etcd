//
//  CardItemView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI
import Alamofire
import Combine
import SwiftUIRouter

struct CardItemView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @State private var showAlert = false
    @State private var pushEdit = false
    @State var options: EtcdClientOption
    @State private var selected:Bool = false;
    var idx : Int
    
    private func didModify() {
        if homeData.selectedItems.contains(options){
            self.selected = true
        }else{
            self.selected = false
        }
        let statut = homeData.ectdClientList[idx].status
    }
    var body: some View {
        NavLink(to: homeData.ectdClientList[idx].id.uuidString){
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
                            Toggle("", isOn: $selected)
                                .toggleStyle(.checkbox)
                                .padding(.bottom,3)
                                .onChange(of:selected) { newValue in
                                    homeData.ectdClientList[idx].checked = newValue
                                    if newValue {
                                        if homeData.selectedItems .contains(options){
                                            return
                                        }
                                        homeData.selectedItems.append(options)
                                    }else{
                                        if homeData.selectedItems.contains(options){
                                            homeData.selectedItems.remove(at:homeData.selectedItems.index(of: options)!)
                                        }
                                    }
                                }
                                .onReceive(Just(selected)) { selection in
                                    self.didModify()
                                }
                        }
                        Text(homeData.ectdClientList[idx].clientName)
                            .withDefaultSubContentTitle(fontColor: .white)
                    }
                    .padding(DefaultSpacePadding)
                }
                VStack(alignment: .center,spacing: 8.0) {
                    Text("节点地址")
                        .withDefaultContentTitle(fontColor: .white)
                        .padding(.bottom,5)
                    VStack(alignment: .center){
                        ForEach(homeData.ectdClientList[idx].getEndpoints(),id: \.self) { item in
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
                    
                    Text(LocalizedStringKey(homeData.ectdClientList[idx].status == true ? "Scuess" : "Failed"))
                        .withDefaultSubContentTitle(fontColor: homeData.ectdClientList[idx].status == true ? Color(hex:"#7CFC00") : .red)
                    Spacer()
                }
            }
            .frame( height: 220)
            .background(Color.init(hex: "#00FFFF").opacity(0.15))
            .cornerRadius(DefaultRadius)
            .buttonStyle(.plain)
        }
        
    }
}

