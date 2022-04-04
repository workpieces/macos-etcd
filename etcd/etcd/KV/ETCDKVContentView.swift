//
//  ETCDKVContentView.swift
//  etcd
//
//  Created by FaceBook on 2022/4/3.
//  Copyright © 2022 Workpiece. All rights reserved.
//

import SwiftUI

/*
 Circle()
 .fill(.red)
 .frame(width: 44, height: 44, alignment: .center)
 .overlay(Text("Hello").foregroundColor(.white))
 */


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
        Button {
            
        } label: {
            Image(systemName: name)
                .withDefaultImage(foreColor: color, width: size)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func withDefaultVHImageButton(name: String, title: String,textColor: Color = .white,color: Color = .white,size: CGFloat = 13) -> some View {
        Button {
            
        } label: {
            VStack(alignment: .center, spacing: 2.0) {
                Image(systemName: name)
                    .withDefaultImage(foreColor: color, width: size)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(textColor)
                
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension NSTableView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        backgroundColor = NSColor.clear.withAlphaComponent(0.35)
        enclosingScrollView!.drawsBackground = false
    }
}


struct SingleKVView: View {
    var title: String
    var body: some View {
        HStack(alignment: .center, spacing: 8.0){
            Image(systemName: "key.icloud")
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
    let json = ["JSON","TEXT"]
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    List{
                        Section {
                            ForEach(storeObj.all(),id: \.key) { item in
                                SingleKVView(title: item.key)
                                    .padding(4.0)
                                    .onTapGesture{
                                        self.selecteItem  = item
                                    }
                            }
                        } header: {
                            HStack {
                                withDefaultHeaderLabelView(title: storeObj.address)
                                Spacer()
                                withDefaultOnlyImageButton(name: "arrow.clockwise.circle",color: .orange,size: 20.0)
                                withDefaultOnlyImageButton(name: "folder.badge.minus",color: .red,size: 22.0)
                                withDefaultOnlyImageButton(name: "plus.circle",color: .green,size: 18.0)
                                withDefaultOnlyImageButton(name: "magnifyingglass",size: 18.0)
                            }
                        }
                    }
                    .frame(width: geometry.size.width / 2.0, height: geometry.size.height)
                    
                    VStack {
                        HStack {
                            Text("Value Size: 13 bytes")
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
                            
                            withDefaultVHImageButton(name: "highlighter", title: "write",size: 14.0)
                            withDefaultVHImageButton(name: "highlighter", title: "copy",size: 14.0)
                            withDefaultVHImageButton(name: "highlighter", title: "save",size: 14.0)
                                .padding(.trailing,10.0)
                        }
                        .frame(height: 44.0)
                        .cornerRadius(DefaultRadius)
                        .background(Color(hex: "#5B9BD4").opacity(0.45))
                        .padding(.trailing,15.0)
                        .padding(.bottom,15.0)
                        
                        if ((selecteItem?.value.isEmpty) != nil) {
                            Text(selecteItem!.value)
                                .frame(minWidth: geometry.size.width / 2.0, maxWidth: .infinity, maxHeight: .infinity)
                        }else{
                            EmptyView()
                        }
                    }
                    
                }
                .padding(.leading,10)
                .padding(.trailing,10)
            }
        }
    }
}
