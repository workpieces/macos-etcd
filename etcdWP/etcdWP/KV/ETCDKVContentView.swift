//
//  ETCDKVContentView.swift
//  etcd
//
//  Created by FaceBook on 2022/4/3.
//  Copyright © 2022 Workpiece. All rights reserved.
//

import SwiftUI
import SwiftyJSON

extension View {
    func withDefaultHeaderLabelView(title: String,fontSize: CGFloat = 13,color: Color =  Color.white) -> some View {
        Label {
            Text(title)
                .withDefaultContentTitle(fontColor: color,fontSize: fontSize)
        } icon: {
            Image(systemName: "books.vertical.circle")
                .withDefaultImage(foreColor: color, width: 22.0)
                .padding(.leading,4.0)
                .padding(.top,8.0)
                .padding(.bottom,8.0)
                .padding(.trailing,4.0)
        }
    }
    
    func withDefaultOnlyImageButton(name: String, color: Color = Color(hex: "#375B7E") ,size: CGFloat = 13) -> some View {
        Image(systemName: name)
            .withDefaultImage(foreColor: color, width: size)
    }
    
    func withDefaultVHImageButton(name: String, title: String,textColor: Color = .white,color: Color = .white,size: CGFloat = 13) -> some View {
        VStack(alignment: .center, spacing: 2.0) {
            if (name .contains(".")){
                Image(systemName:name)
                    .withDefaultImage(foreColor: color, width: size)
                
            }else{
                Image(name)
                    .withDefaultImage(foreColor: color, width: size)
                
            }
        
            Text(title)
                .font(.subheadline)
                .foregroundColor(textColor)
        }
    }
}

extension NSTableView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        backgroundColor = NSColor.clear
        enclosingScrollView!.drawsBackground = false
    }
}



struct SingleKVView: View {
    var title: String
    var body: some View {
        HStack(alignment: .center, spacing: 8.0){
            Image(systemName: "folder")
                .withDefaultImage(foreColor: .white,width: 18.0)
            Text(title)
                .withDefaultSubContentTitle()
            Spacer()
        }
        .contentShape(Rectangle())
        .frame(height:30)
        .frame(maxWidth: .infinity)
        .cornerRadius(3.0)
    }
}

struct ETCDKVContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    @State var jsonIndex: Int = 0
    @State var selecteItem:PairStore?
    @State var items:[PairStore]
    let json = ["JSON","TEXT"]
    
    fileprivate   func TextContentView(_ string: String? ,_ geometry:GeometryProxy) -> some View {
        return Text(string ?? "")
            .frame(minWidth: geometry.size.width / 2.0, maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.white)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    VStack{
                        HStack {
                            withDefaultHeaderLabelView(title: storeObj.address)
                            Spacer()
                            withDefaultOnlyImageButton(name: "arrow.clockwise.circle",color: .orange,size: 20.0).onTapGesture {
                                self.items  = storeObj.Children()
                            }
//                            withDefaultOnlyImageButton(name: "folder.badge.minus",color: .red,size: 22.0)
//                            withDefaultOnlyImageButton(name: "plus.circle",color: .green,size: 18.0)
//                            withDefaultOnlyImageButton(name: "magnifyingglass",size: 18.0)
                        }
                        .frame(width:  geometry.size.width / 2.0, height: 44)
                        List(items, id: \.self ,children:\.pairs){ item in
                            SingleKVView(title: item.key)
                                .padding(4.0)
                                .onTapGesture{
                                    self.selecteItem  = item
                                }
                        }.listStyle(PlainListStyle())
                        .frame(width: geometry.size.width / 2.0, height: geometry.size.height - 48)
                    }
                    Divider()
                        .frame(width:0.5)
                        .frame(maxHeight:geometry.size.height * 0.85)
                        .background(Color.white)
                    VStack {
                        HStack {
                            Text("Value Size:\(selecteItem?.size ?? 0) bytes")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding(.leading,10.0)
                            
                            Picker("View as: ", selection: $jsonIndex) {
                                ForEach(json.indices , id: \.self){ i in
                                    Text(self.json[i])
                                        .foregroundColor(.black)
                                        .font(.subheadline)
                                }
                            }
                            .frame(width: 160.0,height: 20.0)
                            .pickerStyle(.menu)
                            
                            Spacer()
                            
//                            withDefaultVHImageButton(name: "pencil.slash", title: "write",size: 14.0)
                            withDefaultVHImageButton(name: "doc.on.doc", title: "copy",size: 14.0).onTapGesture {
                        
                                var text = ""
                                if jsonIndex == 1{
                                    text = selecteItem?.value ?? ""
                                }else{
                                    let representation  = selecteItem?.value;
                                    text = JSON(representation as Any).rawString()!
                                }
                                let pasteboard = NSPasteboard.general
                                pasteboard.declareTypes([.string], owner: nil)
                                pasteboard.setString(text, forType: .string)
                            }
//                            withDefaultVHImageButton(name: "square.and.arrow.down.on.square.fill", title: "save",size: 14.0)
                                .padding(.trailing,10.0)
                        }
                        .frame(height: 44.0)
                        .cornerRadius(DefaultRadius)
                        .padding(.trailing,15.0)
                        .padding(.bottom,15.0)
                        if jsonIndex == 1{
                            TextContentView(selecteItem?.value,geometry)
                        }else{
                            let representation  = selecteItem?.value;
                            let string = JSON(representation as Any).rawString()
                            TextContentView(string,geometry)
                        }
                    }
                    
                }
                .padding(.leading,10)
                .padding(.trailing,10)
            }
        }
    }
}
