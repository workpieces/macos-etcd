//
//  AboutView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            HStack {
                Text("About Us")
                    .withDefaultNavagationTitle()
                Spacer()
            }
            .padding(.top,NavagationPaddingHeight)
            
            ZStack(alignment: .topLeading){
                ScrollView(.vertical, showsIndicators: true) {
                    // todo 介绍其他产品轮播图
                    Color.green
                        .frame(height: 120.0)
                        .cornerRadius(DefaultRadius)
                        .padding()
                    
                    LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 2), alignment: .center, spacing: GriditemPaddingSpace) {
                        ForEach(abouts) { item in
                            ZStack {
                                Color(hex:"#00FFFF").opacity(0.3)
                                    .cornerRadius(DefaultRadius)
                                VStack {
                                    Text(item.title)
                                        .withDefaultContentTitle(fontSize: 22.0)
                                        .padding(.all,DefaultSpacePadding)
                                    
                                    Text(item.desc)
                                        .withDefaultSubContentTitle(fontSize: 14.0)
                                    
                                    switch item.type {
                                    case .Contact:
                                        HStack(spacing: 20.0){
                                            Image(item.image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(.white)
                                                .frame(width: 44.0)
                                                .padding(.top,DefaultSpacePadding)
                                            Image("email")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(.white)
                                                .frame(width: 40.0)
                                                .padding(.top,DefaultSpacePadding)
                                        }
                                    case .Download:
                                        Text("Download")
                                            .withDefaultContentTitle(fontColor: .white)
                                            .padding(.all,DefaultSpacePadding)
                                            .background(.orange)
                                            .cornerRadius(10.0)
                                            .offset(y: DefaultSpacePadding)
                                    case .Documentation:
                                        Text("Documentation")
                                            .withDefaultContentTitle(fontColor: .white)
                                            .padding(.all,DefaultSpacePadding)
                                            .background(.orange)
                                            .cornerRadius(10.0)
                                            .offset(y: DefaultSpacePadding)
                                    case .Empty:
                                        EmptyView()
                                    }
                                    Spacer()
                                }
                            }
                            .frame(height:210.0)
                            .onTapGesture {
                                NSWorkspace.shared.open(URL.init(string: item.link)!)
                            }
                        }
                    }
                    .padding(GriditemPaddingSpace)
                }
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
