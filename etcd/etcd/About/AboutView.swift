//
//  AboutView.swift
//  etcd
//
//  Created by taoshumin_vendor on 2022/3/11.
//

import SwiftUI

struct ButtonIcon: View {
    var imageName:String = ""
    var titile:String = ""
    var callback:() -> Void = {}
    var body: some View {
        HStack(){
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .clipped()
            Text(titile)
        }.frame(height: 30)
            .padding([.leading, .trailing], 10)
            .onTapGesture{
                callback()
            }
    }
}

struct AboutView: View {
    var body: some View {
        VStack(alignment:.leading){
            ZStack(){
                Image("etc_bg_icon")
                    .resizable()
                    .aspectRatio(contentMode:.fill)
            }.frame(height: 350)
                .clipped()
            Spacer()
            HStack(){
                ForEach(abouts,id: \.self) { item in
                    ButtonIcon(imageName: item.image, titile:item.title) {
                        NSWorkspace.shared.open(URL.init(string: item.link)!)
                    }.padding(.leading ,40)
                }
            }.padding(.bottom, 40)
        }.frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
