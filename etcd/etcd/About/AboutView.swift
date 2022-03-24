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
                    LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 1), alignment: .center, spacing: 15.0) {
                        ForEach(abouts) { item in
                            ZStack {
                                Color.orange
                                    .cornerRadius(GridItemRadius)
                                
                                VStack {
                                    Text(item.title)
                                        .withDefaultContentTitle()
                                        .padding(20)
                                    
                                    Text(item.desc)
                                        .withDefaultContentTitle()
                                        .padding(20)
                                }
                            }
                            .frame(height:240.0)
                            .onTapGesture {
                                
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
