//
//  ETCDExtensionDate+.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/9/22.
//

import Foundation
extension Date {
    /**
     *  是否为今天
     */
    func isToday() -> Bool{
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        
        return (selfCmps.year == nowComps.year) &&
        (selfCmps.month == nowComps.month) &&
        (selfCmps.day == nowComps.day)
        
    }
    
    /**
     *  是否为昨天
     */
    func isYesterday() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        if selfCmps.day == nil || nowComps.day == nil {
            return false
        }
        let count = nowComps.day! - selfCmps.day!
        return (selfCmps.year == nowComps.year) &&
        (selfCmps.month == nowComps.month) &&
        (count == 1)
    }
    
    ///只有年月日的字符串
    func dataWithYMD() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.string(from: self)
        let result = fmt.date(from: selfStr)!
        print(result)
        return selfStr
    }
    
    ///获取当前年月日的时间戳
    func timeIntervalWithYMDDate() -> TimeInterval {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.string(from: self)
        let result = fmt.date(from: selfStr)!
        return result.timeIntervalSinceReferenceDate + 24 * 60 * 60
    }
    /**
     *  是否为今年
     */
    func isThisYear() -> Bool {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: self)
        let result = nowCmps.year == selfCmps.year
        return result
    }
    /**
     *  获得与当前时间的差距
     */
    func deltaWithNow() -> DateComponents{
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.hour,.minute,.second], from: self, to: Date())
        return cmps
    }
}
