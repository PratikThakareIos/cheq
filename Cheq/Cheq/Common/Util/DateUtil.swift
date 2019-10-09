//
//  DateUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class DateUtil {
    
    static let defaultFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    static let shared = DateUtil()
    
    func defaultDateFormatter()-> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateUtil.defaultFormat
        return dateFormatter
    }
}
