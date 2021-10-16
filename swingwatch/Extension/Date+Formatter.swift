//
//  Date+Formatter.swift
//  swingwatch
//
//  Created by 小池智哉 on 2021/10/16.
//

import Foundation

extension Date {
    func toYYYYMMddHHmmssNoDelimiterString() -> String {
        return Date.toYYYYMMddHHmmssNoDelimiterFormatter.string(from: self)
    }
    
    public static let toYYYYMMddHHmmssNoDelimiterFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "YYYYMMddHHmmss"
        return formatter
    }()
}
