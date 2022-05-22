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
                Text("About")
                    .withDefaultNavagationTitle()
                Spacer()
            }
            .padding(.top,NavagationPaddingHeight)
            
            ZStack(alignment: .topLeading){
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 1), alignment: .center, spacing: GriditemPaddingSpace) {
                        ForEach(abouts) { item in
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .black]), startPoint: .leading, endPoint: .trailing)
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
                                            .background(Color.pink)
                                            .cornerRadius(10.0)
                                        
                                    }
                                    .padding(.leading,GriditemPaddingSpace)
                                    .padding(.trailing,GriditemPaddingSpace)
                                }
                                Spacer()
                            }
                            .frame(height: 210)
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
