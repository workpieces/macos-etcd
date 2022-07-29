//
//  ETCDHomeController.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI

struct ETCDHomeController: View {
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
                        Text("Services")
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
                    ScrollView(showsIndicators:false){
                        ETCDADBannerTipView()
                            .frame( height: proxy.safeAreaInsets.top)
                            .padding(.bottom,15)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],spacing: 5){
                            ForEach(0 ..< 100){ idx in
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(Color(hue: 0.1 * Double(idx) , saturation: 1, brightness: 1))
                                .frame(height: 120)
                            }
                        }
                        ETCDADBannerTipView()
                            .frame(height: proxy.safeAreaInsets.top)
                            .padding(.bottom,40)
                    }
                    .padding(.trailing,10)
                    .padding(.leading,10)
                    .padding(.bottom,10)
                }
                
            }
        }
        
    }
}

struct SwiftUILearningCapacityHomeController_Previews: PreviewProvider {
    static var previews: some View {
        ETCDHomeController()
    }
}
