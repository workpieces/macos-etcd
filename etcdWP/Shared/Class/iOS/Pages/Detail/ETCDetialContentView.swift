//
//  ETCDetialContentView.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/8/2.
//

import SwiftUI
import TextSourceful

struct ETCDDetiaContentTextView: View {
    @State var text:String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("值")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .opacity(0.75)
                    .padding(.leading,20)
                    .frame(alignment: .leading)
                Spacer()
                Button {
                    
                } label: {
                    Text("粘贴")
                        .font(.caption)
                        .foregroundColor(Color(hex:"#00FFFF"))
                        .padding(8)
                        .frame(height: 25)
                }.background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                Text("")
                    .frame(width: 10)
            }
            Divider().frame(height:0.5)
            HStack{
                TextSourceCodeTextEditor(text: $text)
                    .lineLimit(nil)
                    .foregroundColor(.secondary)
                    .font(.system(size: 12))
                    .lineSpacing(4)
                    .padding(.top,10)
                    .padding(.bottom,10)
                    .padding(.trailing,10)
                    .multilineTextAlignment(TextAlignment.leading)
            }
        }
    }
}

struct ETCDDetialContentPageView: View {
    @EnvironmentObject var storeObj: ItemStore
    var body: some View {
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
                    .foregroundColor(.white)
            }
            Spacer()
            Button {
                storeObj.Next()
            } label: {
                Text("下一页")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            Spacer()
            Text("总数:  \(storeObj.realeadData.GetKvCount())  ")
                .foregroundColor(.secondary)
                .font(.caption)
            Spacer()
        }
    }
}


struct ETCDDetialContentTreeListPageView: View {
    @EnvironmentObject var storeObj: ItemStore
    var body: some View {
        HStack () {
            Spacer()
            Text("总数:  \(storeObj.realeadData.GetKvCount())  ")
                .foregroundColor(.secondary)
                .font(.caption)
                .padding(10)
            Spacer()
        }.frame( height: 26)
    }
}

struct ETCDDetialContentViewListView: View {
    @EnvironmentObject var storeObj: ItemStore
    var body: some View {
        List(storeObj.realeadData.kvs){ item in
            ETCDKVItemView(item: item)
                .onTapGesture(perform: {
                    self.storeObj.realeadData.currentKv = item
                })
                .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ETCDDetialContentViewTreeListView: View {
    @EnvironmentObject var storeObj: ItemStore
    @State var treeModel :KVData?
    @State fileprivate var isDefaultSelectType: Int = 0
    @State fileprivate var isShowingUpdatePopover = false
    @State fileprivate var textValue: String = ""
    var body: some View {
        VStack{
            if ((treeModel?.children?.isEmpty) != nil) {
                ETCDNodeOutlineGroup( callback: { newValue, index , text in
                    if !text.isEmpty {
                        self.textValue = text
                    }
                    self.isDefaultSelectType = index
                    
                },node: treeModel!, childKeyPath:  \.children)
            }else{
                EmptyView()
            }
        } .onAppear{
            Task{
                treeModel = try?  await storeObj.treeItem()
            }
        }
        
    }
}


struct ETCDDetiaContentListView: View {
    @EnvironmentObject var storeObj: ItemStore
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading){
                if storeObj.showFormat == .List{
                    ETCDDetialContentPageView().frame(height: 40)
                    Divider().frame(height:0.5)
                    ETCDDetialContentViewListView()
                }else{
                    ETCDDetialContentTreeListPageView().frame(height: 40)
                    Divider().frame(height:0.5)
                    ETCDDetialContentViewTreeListView()
                }
            }.onAppear(perform: {
                Task{
                    await  storeObj.KVReaload(false)
                }
            })
        }
        
    }
}


struct ETCDetialContentView: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ETCDDetiaContentListView().frame(width: proxy.size.width * 0.8)
                    ETCDDetiaContentTextView().frame(width: proxy.size.width * 0.5)
                }
            }
        }
    }
}

