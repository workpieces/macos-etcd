//
//  ETCDiPhoneAboutController¡.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI

struct ETCDiPhoneAboutController: View {
    @StateObject var  tableData = HomeTabSelectModel()
    var body: some View {
        GeometryReader { proxy in
            VStack{
                HStack(alignment: .center){
                    ETCDHelpLeftView()
                    Spacer()
                    Text("About")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(height: 40.0, alignment: .leading)
                        .lineLimit(1)
                    Spacer()
                    ETCDHelpRightView()
                }.frame(width:proxy.size.width,height:proxy.safeAreaInsets.top)
                ScrollView(.vertical, showsIndicators: false) {
                    HStack{
                        Image(MacosLogoName)
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                            .frame(width: 60, height: 60)
                        Text(MacEtcdName)
                            .withDefaultContentTitle(fontSize: 30)
                        Spacer()
                        Text("Version: \(tableData.getVersion())")
                            .withDefaultContentTitle()
                        Text("")
                            .frame(width: 30)
                    }.frame(alignment:.leading)
                    ETCDADBannerTipView()
                        .frame(width:proxy.size.width , height: proxy.safeAreaInsets.top)
                        .padding(.leading,15)
                    LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 1), alignment: .center, spacing: GriditemPaddingSpace) {
                        ForEach(abouts) { item in
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.init(hex: "#00FFFF").opacity(0.15), .black]), startPoint: .leading, endPoint: .trailing)
                                HStack(alignment: .top, spacing: GriditemPaddingSpace){
                                    VStack(alignment: .leading, spacing: GriditemPaddingSpace){
                                        HStack(alignment: .bottom, spacing: 10.0) {
                                            Text(LocalizedStringKey(item.title))
                                                .font(.system(size: 25))
                                                .bold()
                                                .foregroundColor(.white)
                                            if item.status != 0 {
                                                Text(LocalizedStringKey(item.status == 1 ? "（已发版）" : "（研发中）"))
                                                    .font(.system(size: 12))
                                                    .foregroundColor(item.status == 1 ? .green : .orange)
                                            }
                                            Spacer()
                                        }
                                        Text(LocalizedStringKey(item.desc))
                                            .font(.system(size: 16))
                                            .lineSpacing(3.0)
                                            .foregroundColor(.white)
                                        
                                        Text(LocalizedStringKey("Learn More"))
                                            .font(.system(size: 16))
                                            .lineSpacing(3.0)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: GriditemPaddingSpace, leading: 20, bottom: GriditemPaddingSpace, trailing: 20))
                                            .background(Color.init(hex: "#00FFFF").opacity(0.15))
                                            .cornerRadius(10.0)
                                        
                                    }
                                    .padding(.leading,GriditemPaddingSpace)
                                    .padding(.trailing,GriditemPaddingSpace)
                                }
                                Spacer()
                            }
                            .cornerRadius(10)
                            .frame(height: 220)
                            .onTapGesture {
                                UIApplication.shared.open(URL.init(string: item.link)!)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
