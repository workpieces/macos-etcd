//
//  ETCDKeyValueDeleView.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/8/2.
//

import SwiftUI
import SwiftUIRouter
let KeyValueDeleRouterName = "KeyValueDele"
struct ETCDKeyValueDeleView: View {
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        GeometryReader { proxy in
            ZStack{
                VStack{
                    HStack{
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .font(.system(size: 18))
                            .padding(10)
                            .frame(width: 45, height: 45)
                            .onTapGesture {
                                navigator.goBack()
                            }
                        Spacer()
                        Text("study swiftui ")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "")
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
