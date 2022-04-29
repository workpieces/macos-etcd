//
//  ETCDLogsObject.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/29.
//

import Foundation
import SwiftUI
import Combine

struct KVOperateLog: Identifiable,Hashable{

    var id  = UUID()
    var time: Date = Date()
    var status: Int?
    var message: String?
    var operate: String
    init(status: Int,message: String,operate: String) {
        self.status = status
        self.message = message
        self.operate = operate
    }
    
    func formatTime() -> String {
        let date = self.time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        var dateStrin = dateFormatter.string(from: date)
        dateStrin.append("  | ")
        return dateStrin ;
    }
    
    
    func formatStatus() -> String {
        let date = String(self.status ?? 0)
        var dateStrin = ""
        dateStrin.append(date)
        dateStrin.append(" | ")
        return dateStrin ;
    }
    
    func formatMessage() -> String {
        let damessagete = self.message ?? ""
        var dateStrin = ""
        dateStrin.append(damessagete)
        return dateStrin ;
    }
    
    func formatOperate() -> String {
        let operateagete = self.operate.uppercased()
        var dateStrin = ""
        dateStrin.append(operateagete)
        dateStrin.append("  | ")
        return dateStrin ;
    }
}


class ETCDLogsObject : NSObject
{
    
    static let shared = ETCDLogsObject()
    private override init() {}
    override func copy() -> Any {
        return self
    }
    
    override func mutableCopy() -> Any {
        return self
    }
    
    // Optional
    func reset() {
        // Reset all properties to default value
    }
    
    let  logSubjec = PassthroughSubject<KVOperateLog, Error>()

    static  func sendLog(status:Int, message:String , operate:String){
        let lg =  KVOperateLog.init(status: status, message: message, operate: operate)
        shared.logSubjec.send(lg)
    }
}



class ETCDLogsObservable: ObservableObject {
    
    @Published var items: [KVOperateLog] = []
    let log = ETCDLogsObject.shared
    var cancellables = Set<AnyCancellable>()
    init() {
       getLoadLogs()
    }
    func getLoadLogs (){
       let _ =  log.logSubjec.sink { completion in
           switch completion {
           case .finished:
               break
           case .failure(let error):
               print("\(error)")
           }
        } receiveValue: { [weak self] value in
            self?.items.append(value)
        }.store(in: &cancellables)
    }
}
