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
    
    func currencyFormat(_ amount: Double)-> String {
        return String(format: "%.2f", amount)
    }
}
