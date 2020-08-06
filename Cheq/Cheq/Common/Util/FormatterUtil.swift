//
//  DateUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 Utility format to do various formatting. Incluing formatting for various Date formats and Currency string format.
 */
class FormatterUtil {
    
    /// detailed time format including precise hours, minutes, seconds and timezone.
    static let defaultFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    /// user-friendly format with date, month and year.
    static let userFriendlyFormat = "dd MMM, yyyy"
    
    /// month shorten-term only format
    static let monthOnly = "MMM"
    
    /// simpleDate with day of month and shorten-term month
    static let simpleDate = "dd MMM"
    
    /// Singleton instance of **FormatterUtil**
    static let shared = FormatterUtil()
    
    
    /// Helper method for setting up **userFriendly** formatter
    func userFriendlyDateFormatter()-> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FormatterUtil.userFriendlyFormat
        return dateFormatter
    }
    
    /// Helper method for setting up **dateFormat** formatter
    func defaultDateFormatter()-> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FormatterUtil.defaultFormat
        return dateFormatter
    }
    
    /// Helper method for setting up **simpleDate** formatter
    func simpleDateFormatter()-> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FormatterUtil.simpleDate
        return dateFormatter
    }
    
    /**
     Helper method for formatting a given Double amount into currency format.
     - parameter amount: amount to format in Double type
     - parameter symbol: the prefix to add before the formatted amount. In this case, it is usually **$**
     - parameter roundDownToNearestDollar: usually we want to the nearest second decimal digit, but in some cases, there is a legal requirement to round down to nearest dollar.
     */
    func currencyFormat(_ amount: Double, symbol: String, roundDownToNearestDollar: Bool)-> String {
        if roundDownToNearestDollar {
            let amt = floor(amount)
            return String(format: "\(symbol)%.0f", amt)
        } else {
            return String(format: "\(symbol)%.2f", amount)
        }
    }
    
    /**
     Helper method for formatting a given Double amount into currency format and add comma
     - parameter amount: amount to format in Double type
     - parameter symbol: the prefix to add before the formatted amount. In this case, it is usually **$**
     - parameter roundDownToNearestDollar: usually we want to the nearest second decimal digit, but in some cases, there is a legal requirement to round down to nearest dollar.
     */

    func currencyFormatWithComma(_ amount: Double, symbol: String, roundDownToNearestDollar: Bool)-> String {
        var amt = amount
        if roundDownToNearestDollar {
          amt = floor(amount)
        }
        var strAmount = amt.round().strWithCommas
        return symbol + strAmount
    }
    
    /**
     Helper method to extract the month value from a given **Date**
     */
    func monthFromDate(_ date: Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FormatterUtil.monthOnly
        return dateFormatter.string(from: date)
    }
    
    /**
     Helper method which converts month enum back to an Int value. This is useful when we want to sort months or use month value as index. E.g. check **BarChartTableViewCellViewModel** 
     */
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
