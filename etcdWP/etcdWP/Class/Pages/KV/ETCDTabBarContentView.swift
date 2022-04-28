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
    @State private var currentMember :KVMemberModel = KVMemberModel.getMembers().first!
    @State private var currentTextValue: MemberTextValue = MemberTextValue.init()
    @State private var isShowingPopover = false
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
                                    .font(.system(size: 12))
                                    .lineSpacing(8.0)
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                                Spacer()
                                Text(item.size!)
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                    .lineSpacing(8.0)
                                    .truncationMode(.middle)
                            }
                        } .onTapGesture(perform: {
                            self.storeObj.realeadData.currentKv = item
                            showingAlert.toggle()
                        })
                        .contextMenu(ContextMenu(menuItems: {
                            Button("粘贴", action: {
                                copyToClipBoard(textToCopy: item.key ?? "")
                            })
                            Button("删除", action: {
                                guard ((item.key?.isEmpty) != nil) else {
                                    let resp =  storeObj.Delete(key: item.key!)
                                    print(resp as Any)
                                    return
                                }
                            })
                        }))

                        .buttonStyle(PlainButtonStyle())
                    }
                } header: {
                    VStack(content: {
                        HStack{
                            Text("服务地址：\(storeObj.address)")
                                .font(.caption)
                                .foregroundColor(.white)
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
                        HStack {
                            VStack {
                                Spacer()
                                HStack{
                                    Text("名称： \(item.members?.name ?? "")")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                        .lineSpacing(8.0)
                                        .truncationMode(.middle)
                                    Spacer()
                                    let mid  = String(item.members?.mid ?? "000000").suffix(6)
                                    Text("ID： \(String(mid))")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                        .lineSpacing(8.0)
                                        .truncationMode(.middle)
                                        .contextMenu(ContextMenu(menuItems: {
                                            Button("粘贴成员", action: {
                                                copyToClipBoard(textToCopy: item.members?.mid ?? "")
                                            })
                                            Button("删除成员", action: {
                                                guard Int(currentTextValue.delete_member_id) != 0 else {
                                                    return
                                                }
                                                
                                                let resp  =  storeObj.MemberRemove(id: Int(currentTextValue.delete_member_id)!)
                                                guard resp?.status == 200 else {
                                                    return
                                                }
                                                print(resp?.message as Any)
                                            })
                                        }))
                                    Spacer()
                                    Rectangle()
                                        .foregroundColor(item.members?.status ?? false ? .red : .green)
                                        .frame(width:8.0,height: 8.0)
                                }
                                .padding(.leading,10)
                                .padding(.trailing,10)
                                
                                Divider()
                                
                                VStack(alignment: .leading){
                                    HStack {
                                        Text("节点： \(item.members?.peer_addr ?? "")")
                                            .font(.system(size: 12))
                                            .foregroundColor(.secondary)
                                            .lineSpacing(8.0)
                                            .truncationMode(.middle)
                                        Spacer()
                                    }
                                    .padding(.leading,10)
                                    .padding(.trailing,10)
                                    
                                    Divider()
                                    HStack {
                                        Text("客户端： \(item.members?.client_addr ?? "")")
                                            .font(.system(size: 12))
                                            .foregroundColor(.secondary)
                                            .lineSpacing(8.0)
                                            .truncationMode(.middle)
                                        Spacer()
                                    }
                                    .padding(.leading,10)
                                    .padding(.trailing,10)
                                }
                                Divider()
                            }
                        }
                        .background(Color.secondary.opacity(0.25))
                        .cornerRadius(8.0)
                        .shadow(radius: 8.0,x: 0.0,y: 8.0)
                    }
                } header: {
                    VStack {
                        HStack(content: {
                            Text("成员（Members）")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                            Text("成员总数:  \(storeObj.realeadData.GetMemberCount()) ")
                                .font(.caption)
                                .foregroundColor(.white)
                        })
                        .padding(.all,4.0)
                        
                        // Create Members / Delete Members / Update Members
                        LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 3), alignment: .center) {
                            ForEach(KVMemberModel.getMembers()) { item in
                                Button {
                                    self.currentMember = item
                                    self.isShowingPopover.toggle()
                                } label: {
                                    Text(item.name)
                                        .font(.caption)
                                        .foregroundColor(.yellow)
                                }
                            }
                        }.popover(isPresented: $isShowingPopover,arrowEdge: .trailing) {
                            MakeMemberPopoverContent(currentModel: $currentMember,textVauleModel: $currentTextValue) {
                                defer {self.isShowingPopover.toggle()}
                                
                                guard currentTextValue.isConfirm else {
                                    return
                                }
                                
                                switch currentTextValue.current_type {
                                case 0:
                                    guard !currentTextValue.peerAddress.isEmpty else {
                                        return
                                    }
                                    
                                    let resp = storeObj.MemberAdd(endpoint: currentTextValue.peerAddress, learner: currentTextValue.isLearner)
                                    guard resp?.status == 200 else {
                                        return
                                    }
                                case 1:
                                    guard Int(currentTextValue.update_member_id_old) != 0 && !currentTextValue.update_member_peer_address_new.isEmpty else {
                                        return
                                    }
                                    
                                    let resp =  storeObj.MemberUpdate(id: Int(currentTextValue.update_member_id_old)!, peerUrl: currentTextValue.update_member_peer_address_new)
                                    guard resp?.status == 200 else {
                                        return
                                    }
                                case 2:
                                    guard Int(currentTextValue.promotes_member_id) != 0 else {
                                        return
                                    }
                                    
                                    let resp = storeObj.MemberPromotes(id: Int(currentTextValue.promotes_member_id)!)
                                    guard resp?.status == 200 else {
                                        return
                                    }
                                default:
                                    guard !currentTextValue.peerAddress.isEmpty else {
                                        self.isShowingPopover.toggle()
                                        return
                                    }
                                    
                                    let resp = storeObj.MemberAdd(endpoint: currentTextValue.peerAddress, learner: currentTextValue.isLearner)
                                    guard resp?.status == 200 else {
                                        return
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
            .frame(minHeight: 180.0, idealHeight: 180.0, maxHeight: 250)
        }
    }
}

struct ETCDKVOperateContentView: View {
    var body: some View {
        GeometryReader {  g in
            HStack {
                MakeOperateKvTextContentView()
                    .frame(width: g.size.width/2)
                Spacer()
                MakeOperateButtonContentView()
                    .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                    .frame(width: g.size.width/2)
                Spacer()
            }
        }
    }
}

struct MakeOperateKvTextContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    @State private var isShowJSON = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Spacer()
                HStack {
                    Text(storeObj.realeadData.currentKv?.value ?? "")
                        .lineLimit(nil)
                        .foregroundColor(.secondary)
                        .font(.system(size: 12))
                        .lineSpacing(4)
                        .multilineTextAlignment(TextAlignment.leading)
                        .contextMenu(ContextMenu(menuItems: {
                            Button("粘贴键值", action: {
                                copyToClipBoard(textToCopy: storeObj.realeadData.currentKv?.value ?? "")
                            })
                        }))
                    Spacer()
                    Button {
                        copyToClipBoard(textToCopy: storeObj.realeadData.currentKv?.value ?? "")
                    } label: {
                        Text("粘贴")
                            .font(.system(size: 10.0))
                            .foregroundColor(.yellow)
                    }
                }
                Spacer()
            }
        }
    }
}

struct MakeOperateButtonContentView :View {
    @State var show: Bool = false
    @State var text: String = ""
    @State var isShowToast: Bool = false
    @State var isSucceFul: Bool = false
    @State var currentModel :KVOperateModel = KVOperateModel.getItems().first!
    @EnvironmentObject var storeObj : ItemStore
    var body: some View {
        ZStack(alignment: .topLeading){
            List {
                ForEach(KVOperateModel.getItems()) { item in
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(item.name)
                                .font(.body)
                                .foregroundColor(.yellow)
                                .truncationMode(.middle)
                                .frame(maxHeight: 44.0)
                            Text(item.english)
                                .font(.body)
                                .foregroundColor(.yellow)
                                .truncationMode(.middle)
                                .frame(maxHeight: 44.0)
                            Spacer()
                        }
                        Spacer()
                    }.onTapGesture {
                        self.currentModel = item
                        if item.type == 3{
                            let reuslt =  storeObj.LeaseRevoke(leaseid: Int(storeObj.realeadData.currentKv?.ttlid ?? 0))
                            if reuslt?.status != 200{
                                self.isShowToast.toggle()
                            }else{
                                self.isSucceFul .toggle()
                                self.isShowToast.toggle()
                            }
                        }else{
                            self.show.toggle()
                        }
                    }
                    .background(Color.secondary.opacity(0.15))
                    .cornerRadius(8)
                    .clipped()
                }
            }
            .padding(8.0)
            
        }.sheet(isPresented: $show, onDismiss: didDismiss) {
            ETCDSheetView(currentModel:$currentModel, text:storeObj.realeadData.currentKv?.value ?? "")
        }
        .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 5) {
            TopToastView(title:self.isSucceFul ? "移除租约成功":"移除租约错误")
           }
    }
    
    func didDismiss() {
        //消失回调
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
                Text(item.formatStatus())
                    .font(.subheadline)
                    .foregroundColor(item.status == 200 ? .yellow: .red)
                    .opacity(0.75)
                Text(item.formatOperate())
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .opacity(0.75)
                Text(item.formatMessage())
                    .font(.subheadline)
                    .foregroundColor(item.status == 200 ? .secondary : .red)
                    .opacity(item.status == 200 ? 0.75 : 1.0)
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
                    ETCDTableViewRepresentableBootcamp()
                        .padding(.leading,10)
                        .padding(.trailing,10)
                        .cornerRadius(10.0)
                        .border(Color(hex: "#5B9BD4").opacity(0.30),width: 0.5)
                } header: {
                    HStack {
                        Text("集群状态")
                            .foregroundColor(.yellow)
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
                            .foregroundColor(.yellow)
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
                            .foregroundColor(.yellow)
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
                .padding(.bottom,-10)
                .offset(y: -20)
                
                HStack(spacing: 20.0){
                    Spacer()
                    Button(action: {
                        NSWorkspace.shared.open(URL.init(string: DefaultOfficialWebsite)!)
                    }, label: {
                        Text("访问官网")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    })
                    Button {
                        NSWorkspace.shared.open(URL.init(string: DefaultFeedback)!)
                    } label: {
                        Text("意见反馈")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.bottom,10)
            }
        })
        .onAppear(perform: {
            storeObj.KVReaload()
        })
        .popup(isPresented: $isShowToast, type: .toast, position: .top, animation: .spring(), autohideIn: 15) {
            TopToastView(title: "The network connection is abnormal, please check the relevant configuration ?")
        }
    }
}



