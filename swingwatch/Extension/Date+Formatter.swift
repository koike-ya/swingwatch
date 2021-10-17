//
//  Date+Formatter.swift
//  swingwatch
//
//  Created by 小池智哉 on 2021/10/16.
//

import Foundation

extension Date {
    private func getMicroseconds() -> Int {
        let nanoseconds = Calendar.current.dateComponents([.nanosecond], from: self).nanosecond ?? 0
        // microsecond以降は正確ではないため、nanosecondsを取り出したら以下のようにroundして使用する必要がある。
        // nanosecond = round(Double(nanosecond) / 1000) * 1000
        return Int(round(Double(nanoseconds) / 1000))
    }
    
    func toYYYYMMddHHmmssNoDelimiterString() -> String {
        return Date.toYYYYMMddHHmmssNoDelimiterFormatter.string(from: self)
    }
    
    func toYYYYMMddHHmmssZZZZZZString() -> String {
        let microseconds = getMicroseconds()
        return Date.toYYYYMMddHHmmssFormatter.string(from: self) + ".\(String(format: "%06d", microseconds))"
    }
    
    public static let toYYYYMMddHHmmssNoDelimiterFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "YYYYMMddHHmmss"
        return formatter
    }()
    
    private static let toYYYYMMddHHmmssFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        return formatter
    }()
}
