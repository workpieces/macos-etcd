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
    func withDefaultHeaderLabelView(title: String,fontSize: CGFloat = 13,color: Color =  Color(hex: "#375B7E")) -> some View {
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
            Image(name)
                .withDefaultImage(foreColor: color, width: size)
            
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
                            withDefaultOnlyImageButton(name: "arrow.clockwise.circle",color: .orange,size: 20.0)
                            withDefaultOnlyImageButton(name: "folder.badge.minus",color: .red,size: 22.0)
                            withDefaultOnlyImageButton(name: "plus.circle",color: .green,size: 18.0)
                            withDefaultOnlyImageButton(name: "magnifyingglass",size: 18.0)
                        }
                        .frame(width:  geometry.size.width / 2.0, height: 44)
                        List(items, id: \.self ,children:\.pairs){ item in
                            SingleKVView(title: item.key)
                                .padding(4.0)
                                .onTapGesture{
                                    self.selecteItem  = item
                                }
                        }.listStyle(PlainListStyle())
                        .frame(width: geometry.size.width / 2.0, height: geometry.size.height - 44)
                        
                    }.background(Color.black.opacity(0.2))
                    VStack {
                        HStack {
                            Text("Value Size:13 bytes")
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
                            
                            withDefaultVHImageButton(name: "write", title: "write",size: 14.0)
                            withDefaultVHImageButton(name: "copy", title: "copy",size: 14.0).onTapGesture {
                        
                                var text = ""
                                if jsonIndex == 1{
                                    text = selecteItem?.value ?? ""
                                }else{
                                    let representation  = selecteItem?.toJSON();
                                    text = JSON(representation).rawString()!
                                }
                                let pasteboard = NSPasteboard.general
                                pasteboard.declareTypes([.string], owner: nil)
                                pasteboard.setString(text, forType: .string)
                            }
                            withDefaultVHImageButton(name: "save", title: "save",size: 14.0)
                                .padding(.trailing,10.0)
                        }
                        .frame(height: 44.0)
                        .cornerRadius(DefaultRadius)
                        .background(Color(hex: "#5B9BD4").opacity(0.45))
                        .padding(.trailing,15.0)
                        .padding(.bottom,15.0)
                        if jsonIndex == 1{
                            TextContentView(selecteItem?.value,geometry)
                        }else{
                            
                            let representation  = selecteItem?.toJSON();
                            let string = JSON(representation).rawString()
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
