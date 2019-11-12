//
//  DateUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class FormatterUtil {
    
    static let defaultFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let userFriendlyFormat = "ddd, DD MM"
    static let monthOnly = "MMM"
    static let simpleDate = "DD MMM"
    
    static let shared = FormatterUtil()
    
    func userFriendlyDateFormatter()-> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FormatterUtil.userFriendlyFormat
        return dateFormatter
    }
    
    func defaultDateFormatter()-> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FormatterUtil.defaultFormat
        return dateFormatter
    }
    
    func simpleDateFormatter()-> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FormatterUtil.simpleDate
        return dateFormatter
    }
    
    func currencyFormat(_ amount: Double, symbol: String, roundDownToNearestDollar: Bool)-> String {
        if roundDownToNearestDollar {
            let amt = floor(amount)
            return String(format: "\(symbol)%.0f", amt)
        } else {
            return String(format: "\(symbol)%.2f", amount)
        }
    }
    
    func monthFromDate(_ date: Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FormatterUtil.monthOnly
        return dateFormatter.string(from: date)
    }
    
    static func monthToInt(_ month: Month)-> Int {
        switch month {
        case .Jan: return 1
        case .Feb: return 2
        case .Mar: return 3
        case .Apr: return 4
        case .May: return 5
        case .Jun: return 6
        case .Jul: return 7
        case .Aug: return 8
        case .Sep: return 9
        case .Oct: return 10
        case .Nov: return 11
        case .Dec: return 12
        }
    }
}
