//
//  ETCDReachability.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/7/23.
//

import Foundation
import Alamofire

enum ETCDReachabilityStatus{
    case ETCDNotReachable
    case ETCDUnknown
    case ETCDEthernetOrWiFi
    case ETCDWwan
 
}

class ETCDReachabilityManage: NSObject {
    static let mannger = ETCDReachabilityManage()
    func netWorkReachability(reachabilityStatus: @escaping(ETCDReachabilityStatus)->Void){
        let manager = NetworkReachabilityManager.init()
        manager!.startListening { (status) in
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.ethernetOrWiFi){
                 reachabilityStatus(.ETCDEthernetOrWiFi)
            }
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable{
                reachabilityStatus(.ETCDNotReachable)
                
            }
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.unknown{
                reachabilityStatus(.ETCDUnknown)
            }
            //蜂窝
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.cellular){

                reachabilityStatus(.ETCDWwan)
            }
        }
    }
}
