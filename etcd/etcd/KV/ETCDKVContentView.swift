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
    backgroundColor = NSColor.red
    enclosingScrollView!.drawsBackground = false
  }
}


struct ETCDKVContentView: View {
    @EnvironmentObject var storeObj : ItemStore
    var address : String = "0.0.0.0:2379"
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    List{
                        Section {
                            ForEach(storeObj.all(),id: \.key) { item in
                                HStack {
                                    Text(item.key)
                                        .withDefaultSubContentTitle(fontColor: .black, fontSize: 12.0)
                                        .padding(3.0)
                                    Spacer()
                                }
                                .background(.pink)
                                .frame(width:  geometry.size.width / 2.0, height: 44.0, alignment: .leading)
                            }
                        } header: {
                            HStack {
                                withDefaultHeaderLabelView(title: address)
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
                        Color.red
                            .frame(width: geometry.size.width / 2.0, height: geometry.size.height/2.0)
                        Color.yellow
                            .frame(width: geometry.size.width / 2.0, height: geometry.size.height/2.0)
                    }
                }
                .padding(.leading,10)
                .padding(.trailing,10)
            }
        }
    }
}
