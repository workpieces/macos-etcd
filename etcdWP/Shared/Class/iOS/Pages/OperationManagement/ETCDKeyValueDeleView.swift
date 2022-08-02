//
//  ETCDKeyValueDeleView.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/8/2.
//

import SwiftUI

let KeyValueDeleRouterName = "/KeyValueDele"


struct ETCDKeyValueDeleView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack{
                VStack{
                    HStack{
                        Image(systemName: "")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                        Spacer()
                        Text("study swiftui ")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                    }.frame(height:proxy.safeAreaInsets.top)
                    Text("Text").frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
            }
        }
        
    }
}

struct ETCDKeyValueDeleView_Previews: PreviewProvider {
    static var previews: some View {
        ETCDKeyValueDeleView()
    }
}
