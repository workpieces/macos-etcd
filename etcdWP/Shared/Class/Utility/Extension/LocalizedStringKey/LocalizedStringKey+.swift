//
//  LocalizedStringKey+.swift
//  etcdWP
//
//  Created by FaceBook on 2022/4/26.
//

import Foundation
import SwiftUI

extension LocalizedStringKey {
    var stringKey: String {
        let description = "\(self)"
        let components = description.components(separatedBy: "key: \"")
            .map { $0.components(separatedBy: "\",") }
        return components[1][0]
    }
}

extension String {
    static func localizedString(for key: String,
                                locale: Locale = .current) -> String {
        var language = locale.languageCode
        if language == "zh"{
            language = language! + "-Hans"
        }
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        return localizedString
    }
}

extension LocalizedStringKey {
    
    func stringValue(locale: Locale = .current) -> String {
        
        return .localizedString(for: self.stringKey, locale: locale)
    }
}
