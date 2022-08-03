//
//  ETCDHomeDetailNavigationView.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/31.
//

import SwiftUI
import SwiftUIRouter

struct ETCDHomeDetailNavigationView: View {
    let title:String
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .center){
                Button {
                    navigator.goBack()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.white)
                        .frame(width: 18,height: 18)
                        .padding(.leading,15)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                Text(LocalizedStringKey(title))
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(height: 40.0, alignment: .leading)
                    .lineLimit(1)
                Spacer()
                Menu {
                    Text("study swiftui ")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("study swiftui ")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("study swiftui ")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("study swiftui ")
                        .font(.title)
                        .fontWeight(.semibold)
                    Text("study swiftui ")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                } label: {
                    Text(LocalizedStringKey("Services"))
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(5)
                        .frame(maxHeight: 25)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(5)
                        .buttonStyle(.plain)
                }.padding(.trailing ,15)

            }.frame(width:proxy.size.width,height:proxy.safeAreaInsets.top)
            
        }
    }
}

