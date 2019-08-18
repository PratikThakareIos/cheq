//
//  CommonEnums.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit


enum Month: String, CaseIterable {

    case Jan
    case Feb
    case Mar
    case Apr
    case May
    case Jun
    case Jul
    case Aug
    case Sep
    case Oct
    case Nov
    case Dec

    var string: String {
        switch self {
        case .Jan: return "Jan"
        case .Feb: return "Feb"
        case .Mar: return "Mar"
        case .Apr: return "Apr"
        case .May: return "May"
        case .Jun: return "Jun"
        case .Jul: return "Jul"
        case .Aug: return "Aug"
        case .Sep: return "Sep"
        case .Oct: return "Oct"
        case .Nov: return "Nov"
        case .Dec: return "Dec"
        }
    }

    static let allStringValues = [Jan.string, Feb.string, Mar.string, Apr.string, May.string, Jun.string, Jul.string, Aug.string, Sep.string, Oct.string, Nov.string, Dec.string]
}

enum FinancialPeriod: CaseIterable {

    case month
    case quarterly
    case annually

    var string: String {
        switch self {
        case .month: return "Monthly"
        case .quarterly: return "Quarterly"
        case .annually: return "Annually"
        }
    }

    static let allStringValues = [month.string, quarterly.string, annually.string]
}
