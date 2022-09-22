//
//  ETCDGoogleAdsModel.swift
//  etcdWP (iOS)
//
//  Created by Google on 2022/9/22.
//

import Foundation
import WCDBSwift

class ETCDGoogleAdsModel: TableCodable {
    init(adSourceID: String, time: Double,timeFormat:String ,hitCount:Int) {
        self.adSourceID = adSourceID
        self.time = time
        self.hitCount = hitCount
        self.timeFormat  = timeFormat
    }
    convenience init() {
        self.init(adSourceID: "", time:0.0,timeFormat: "",hitCount: 0)
    }
    
    var adSourceID: String?
    var time: Double?
    var timeFormat: String?
    var id: Int?
    var hitCount:Int?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ETCDGoogleAdsModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case adSourceID
        case time
        case timeFormat
        case hitCount
        case id
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .id: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true),
            ]
        }
    }
    var isAutoIncrement: Bool = false
    var lastInsertedRowID: Int64 = 0
}

