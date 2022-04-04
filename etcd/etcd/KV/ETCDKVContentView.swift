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
    @State var selecteItem:PairStore?
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
                        Text(selecteItem!.value)
                            .frame(minWidth: geometry.size.width / 2.0, maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding(.leading,10)
                .padding(.trailing,10)
            }
        }
    }
}
