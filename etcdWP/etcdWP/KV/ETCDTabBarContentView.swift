//
//  HomeConnectView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/12.
//

import SwiftUI
import NavigationStack
import PopupView

struct ETCDKeyListContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    @State private var showingAlert: Bool = false
    func Reaload() {
        storeObj.KVReaload()
    }
    
    func DeleteKey(key: String) -> Bool{
        defer {storeObj.KVReaload()}
        let data = storeObj.Delete(key: key)
        if ((data?.datas?.isEmpty) != nil) {
            return false
        }
        if data?.status != 200 {
            return false
        }
        return true
    }
    
    func DeleteALL() -> Bool{
        defer {storeObj.KVReaload()}
        let data = storeObj.DeleteALL()
        if ((data?.datas?.isEmpty) != nil) {
            return false
        }
        if data?.status != 200 {
            return false
        }
        return true
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(storeObj.realeadData.kvs) { item in
                        ZStack {
                            HStack {
                                Image(systemName: DefaultKeyImageName)
                                    .foregroundColor(.orange)
                                    .font(.system(size: 12.0))
                                Text(item.key!)
                                    .foregroundColor(.white)
                                    .font(.system(size: 11.0,weight: .semibold))
                                    .lineSpacing(8.0)
                                    .truncationMode(.middle)
                                Spacer()
                                Text(item.size!)
                                    .foregroundColor(.white)
                                    .font(.system(size: 11.0,weight: .semibold))
                                    .lineSpacing(8.0)
                                    .truncationMode(.middle)
                            }
                        }
                        .onTapGesture(perform: {
                            showingAlert.toggle()
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                } header: {
                    VStack(content: {
                        HStack{
                            Text("服务地址：\(storeObj.address)")
                                .font(.caption)
                                .foregroundColor(Color(hex: "#5B9BD4"))
                            Spacer()
                            
                            if storeObj.status {
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
                                    .foregroundColor(.yellow)
                            }
                            Button {
                                if !self.DeleteALL() {
                                    print("Clean")
                                }
                            } label: {
                                Text("清空键值")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            }
                            
                            Spacer()
                            
                            Button {} label: {
                                Text("查询")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            }
                        }
                        Spacer()
                    })
                }
            }
            .listRowInsets(nil)
            .listStyle(.inset)
            
            HStack {
                Spacer()
                Text("当前页:  \(storeObj.realeadData.GetCurrentPage())  ")
                    .foregroundColor(.secondary)
                    .font(.caption)
                Spacer()
                Button {
                    storeObj.Last()
                } label: {
                    Text("上一页")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
                Spacer()
                Button {
                    storeObj.Next()
                } label: {
                    Text("下一页")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
                Spacer()
                Text("总数:  \(storeObj.realeadData.GetKvCount())  ")
                    .foregroundColor(.secondary)
                    .font(.caption)
                Spacer()
            }
            List {
                Section {
                    ForEach(storeObj.realeadData.members) { item in
                        VStack {
                            HStack {
                                Text("成员名称: ")
                                    .font(.system(size: 12.0,weight: .semibold))
                                    .foregroundColor(.secondary)
                                    .lineSpacing(8.0)
                                    .truncationMode(.middle)
                                Text(item.members?.name ?? "")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 11.0,weight: .semibold))
                                    .lineSpacing(8.0)
                                    .truncationMode(.middle)
                                Spacer()
                                if ((item.members?.status) != nil) {
                                    Rectangle()
                                        .fill(Color.green)
                                        .frame(width: 10, height: 10)
                                }else{
                                    Rectangle()
                                        .fill(Color.red)
                                        .frame(width: 10, height: 10)
                                }
                            }
                            
                            HStack {
                                Text("成员ID: ")
                                    .font(.system(size: 12.0,weight: .semibold))
                                    .foregroundColor(.secondary)
                                    .lineSpacing(8.0)
                                    .truncationMode(.middle)
                                
                                Text(item.members?.mid ?? "")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 11.0,weight: .semibold))
                                    .lineSpacing(8.0)
                                    .truncationMode(.middle)
                                Spacer()
                            }
                            
                            Divider()
                        }
                    }
                } header: {
                    VStack {
                        HStack(content: {
                            Text("成员相关")
                                .font(.caption)
                                .foregroundColor(Color(hex: "#5B9BD4"))
                            Spacer()
                            Text("成员总数量:  \(storeObj.realeadData.GetMemberCount()) 位")
                                .font(.caption)
                                .foregroundColor(Color(hex: "#5B9BD4"))
                        })
                        .padding(.all,4.0)
                    }
                }
                
            }
            .frame(height: 180.0)
        }
    }
}


struct ETCDKVOperateContentView: View {
    var body: some View {
        GeometryReader {  g in
            HStack {
                Color.red
                    .frame(width: g.size.width/2)
                MakeOperateButtonContentView(callback: { newValue, model in
                    
                })
                .frame(width: g.size.width/2)
            }
        }
    }
}

struct MakeOperateButtonContentView :View {
    @State var showingPopup: String? = nil
    @State var show: Bool = false
    var callback:(_ newValue: Bool, _ model:KVOperateModel) -> Void
    let operateModels : [KVOperateModel] = [
        KVOperateModel.init(name: "创建键值", english: "（PutWithTTL）",type: 0),
        KVOperateModel.init(name: "前缀删除", english: "（DeletePrefix）",type: 0),
        KVOperateModel.init(name: "创建租约", english: "（LeaseGrant）",type: 0),
        KVOperateModel.init(name: "移除租约", english: "（LeaseRevoke）",type: 0),
        KVOperateModel.init(name: "租约列表",english: "（LeaseList）", type: 0),
    ]
    var body: some View {
        ZStack(alignment: .topLeading){
            List {
                ForEach(operateModels) { item in
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(item.name)
                                .font(.body)
                                .foregroundColor(.green)
                                .truncationMode(.middle)
                                .frame(maxHeight: 44.0)
                            Text(item.english)
                                .font(.body)
                                .foregroundColor(.green)
                                .truncationMode(.middle)
                                .frame(maxHeight: 44.0)
                            Spacer()
                        }
                        Spacer()
                    }.onTapGesture {
                        self.showingPopup = "string"
                        self.show.toggle()
                        callback(self.show,item)
                    }
                    .background(Color.secondary.opacity(0.15))
                    .cornerRadius(8)
                    .clipped()
                }
            }
            .padding(8.0)
        }.popup(item: $showingPopup, type: .`default`, closeOnTap: true) {
            AlerPopup()
        }
    }
    
    func AlerPopup() -> some View {
        VStack(spacing: 10) {
            Text("adsfadsfasdfadsf")
                .foregroundColor(.white)
                .fontWeight(.bold)
            Text("adsfadsfasdfadsf")
                .foregroundColor(.white)
                .fontWeight(.bold)
            HStack{
                Button {
                    self.showingPopup = nil
                } label: {
                    Text("Got it")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                .frame(width: 100, height: 40)
                .background(Color.white)
                .cornerRadius(20.0)
                Button {
                    self.showingPopup = nil
                } label: {
                    Text("Got it")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                .frame(width: 100, height: 40)
                .background(Color.white)
                .cornerRadius(20.0)
                Button {
                    self.showingPopup = nil
                } label: {
                    Text("Got it")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                .frame(width: 100, height: 40)
                .background(Color.white)
                .cornerRadius(20.0)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background(Color.red)
        .cornerRadius(10.0)
        .frame( minHeight: 300,maxHeight: .infinity)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
    }
}

struct ETCDKVLogsContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    var body: some View {
        List(storeObj.GetLogs(),id:\.self){ item in
            HStack{
                Text(item.formatTime())
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .opacity(0.75)
                    .frame(minHeight: 30, maxHeight: .infinity)
                Text(item.formatStatus())
                    .font(.subheadline)
                    .foregroundColor(item.status == 200 ? .yellow: .red)
                    .opacity(0.75)
                    .frame(minHeight: 30, maxHeight: .infinity)
                Text(item.formatOperate())
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .opacity(0.75)
                    .frame(minHeight: 30, maxHeight: .infinity)
                Text(item.formatMessage())
                    .font(.subheadline)
                    .foregroundColor(item.status == 200 ? .secondary : .red)
                    .opacity(item.status == 200 ? 0.75 : 1.0)
                    .frame(minHeight: 30, maxHeight: .infinity)
            }
        }
    }
}

struct ETCDKVGridContentView: View {
    @State var putSelect = false
    var body: some View {
        ZStack(alignment: .topLeading){
            VStack(alignment: .leading,spacing: 10.0){
                Section {
                    ETCDTableViewRepresentableBootcamp().background(Color.red)
                        .padding(.leading,10)
                        .padding(.trailing,10)
                        .cornerRadius(10.0)
                        .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                } header: {
                    HStack {
                        Text("集群状态")
                            .foregroundColor(.orange)
                            .padding(.leading,20)
                        Spacer()
                    }
                }
                
                Section {
                    ETCDKVOperateContentView()
                        .padding(.leading,10)
                        .padding(.trailing,10)
                        .cornerRadius(10.0)
                        .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                } header: {
                    HStack {
                        Text("键值操作")
                            .foregroundColor(.orange)
                            .padding(.leading,20)
                        Spacer()
                    }
                }
                
                Section {
                    ETCDKVLogsContentView()
                        .padding(.leading,10)
                        .padding(.trailing,10)
                        .cornerRadius(10.0)
                        .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                } header: {
                    HStack {
                        Text("操作日志")
                            .foregroundColor(.orange)
                            .padding(.leading,20)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ETCDTabBarContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    @State private var isPopView = false
    @State private var isShowToast = false
    var body: some View {
        ZStack(alignment: .topLeading, content: {
            VStack {
                withDefaultNavagationBack(title: "ETCD CLUSTER V3", isPop: $isPopView)
                    .padding(.vertical,30)
                    .padding(.leading ,20)
                GeometryReader {  g in
                    HStack(spacing: 10.0) {
                        ETCDKeyListContentView()
                            .frame(width: g.size.width/3.0)
                            .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                        ETCDKVGridContentView()
                            .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                    }
                }
                .padding(.leading,15)
                .padding(.trailing,15)
                .padding(.bottom,20)
                .offset(y: -20)
            }
        })
        .onAppear(perform: {
            storeObj.KVReaload()
        })
        .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 15) {
            TopToastView()
        }
    }
}



