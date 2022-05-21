//
//  Carousel.swift
//  TruyenTranh24h
//
//  Created by Huynh Tan Phu on 20/04/2021.
//

import Foundation

public struct Carousel: Identifiable, Decodable {
    public var id = UUID()
    public let stringURL: String
    
    public init(stringURL: String) {
        self.stringURL = stringURL
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
