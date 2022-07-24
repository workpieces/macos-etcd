//
//  ETCDAboutViewControlleView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/19.
//

import SwiftUI

struct ETCDAboutViewControlleView: View {
    var body: some View {
        VStack{
            ETCDADBannerTipView()
            Spacer().frame( height: 20)
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
