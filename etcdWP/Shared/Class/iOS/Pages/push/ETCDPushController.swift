//
//  ETCDPushController.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

struct ETCDPushController: View {
    @State private var isToast = false
     var callHander : () -> ()
    init(callHander:@escaping () -> Void) {
        UITableView.appearance().backgroundColor = UIColor(rgb: 0x262626)
        UITableView.appearance().showsVerticalScrollIndicator = false
        self.callHander = callHander
    }
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
                            .frame(width: 60, height: 45)
                        Spacer()
                        Text("plus.circle.fill")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("Save")
                            .fontWeight(.semibold)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(.leading,10)
                            .padding(.trailing,10)
                            .frame(width: 60,height: 44.0)
                            .buttonStyle(PlainButtonStyle())
                            .background(Color(hex:"#00FFFF").opacity(0.75))
                            .cornerRadius(10.0)
                            .onTapGesture {
                                callHander()
                            }
                        Divider().frame(width: 15)
                    }.frame(height:proxy.safeAreaInsets.top)
                    
                    List{
                        ETCDUserConfigFormView()
                            .padding(.bottom,20)
                            .padding(.leading,10)
                            .padding(.trailing,10)
                            .onTapGesture {
                                dissmissKeybord()
                            }
                        ETCDNetworkConfigFormView()
                            .padding(.bottom,20)
                            .padding(.leading,10)
                            .padding(.trailing,10)
                        ETCDClusterNetworkConfigFormView()
                            .padding(.bottom,20)
                            .padding(.leading,10)
                            .padding(.trailing,10)
                            .onTapGesture {
                                dissmissKeybord()
                            }
                        ETCDOtherConfigFormView()
                            .padding(.bottom,20)
                            .padding(.leading,10)
                            .padding(.trailing,10)
                    }
                }
                
            }
        }
        
    }
}

