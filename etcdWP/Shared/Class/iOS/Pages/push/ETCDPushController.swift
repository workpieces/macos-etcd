//
//  ETCDPushController.swift
//  etcdWP (iOS)
//
//  Created by FaceBook on 2022/7/27.
//

import SwiftUI
import PopupView

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
    @EnvironmentObject var homeData: HomeViewModel
    @StateObject private var config = ETCDConfigModel()
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
                        Text(LocalizedStringKey("通用设置"))
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
                                let etcdClient  =   EtcdClientOption.init(id: config.id, endpoints: config.endpoints, clientName: config.clientName, username: config.username, password: config.password, certFile: config.certFile, keyFile: config.keyFile, caFile: config.caFile,
                                                                          requestTimeout: config.requestTimeout,
                                                                          dialTimeout: config.dialTimeout, dialKeepAliveTime: config.dialKeepAliveTime,
                                                                          dialKeepAliveTimeout: config.dialKeepAliveTimeout,
                                                                          autoSyncInterval: config.autoSyncInterval,
                                                                          autoPing: config.autoPing,
                                                                          autoName: config.autoName,
                                                                          autoSession: config.autoSession,
                                                                          autoConnect: config.autoConnect,
                                                                          createAt: config.createAt,
                                                                          updateAt: config.updateAt,
                                                                          status: config.status,
                                                                          etcdClient: config.etcdClient,
                                                                          checked: config.checked)
                                do{
                                    try self.homeData.Register(item: etcdClient)
                                    self.homeData.Append(data: etcdClient)
                                    callHander()
                                }catch let error  as  NSError {
                                    self.isToast.toggle()
                                }
                            }
                        Divider().frame(width: 15)
                    }.frame(height:proxy.safeAreaInsets.top)
                    
                    List{
                        ETCDADBannerTipView()
                            .padding(.bottom,40)
                        ETCDUserConfigFormView(config: config)
                            .padding(.bottom,20)
                            .padding(.leading,10)
                            .padding(.trailing,10)
                            .onTapGesture {
                                dissmissKeybord()
                            }
                        ETCDNetworkConfigFormView(config: config)
                            .padding(.bottom,20)
                            .padding(.leading,10)
                            .padding(.trailing,10)
                        ETCDClusterNetworkConfigFormView(config: config)
                            .padding(.bottom,20)
                            .padding(.leading,10)
                            .padding(.trailing,10)
                            .onTapGesture {
                                dissmissKeybord()
                            }
                        ETCDOtherConfigFormView(config: config)
                            .padding(.bottom,20)
                            .padding(.leading,10)
                            .padding(.trailing,10)
                        ETCDADBannerTipView()
                            .padding(.bottom,40)
                    }
                }
                
            }.popup(isPresented: $isToast, type:.toast, position: .top, animation: .spring(), autohideIn: 2) {
                TopToastView(title: "The network connection is abnormal, please check the relevant configuration ?")
            }
        }
        
    }
}

