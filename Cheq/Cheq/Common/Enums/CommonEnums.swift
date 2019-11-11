//
//  CommonEnums.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import Foundation

enum CurrencySymbol: String {
    case dollar = "$"
}

enum LargeCategoryEmoji: String {
    case benefits = "large/benefits"
    case billsUtilities = "large/billsUtilities"
    case employmentIncome = "large/employmentIncome"
    case entertainment = "large/entertainment"
    case financialServices = "large/financialServices"
    case fitness = "large/fitness"
    case groceries = "large/groceries"
    case health = "large/health"
    case homeFamily = "large/homeFamily"
    case ondemandIncome = "large/ondemandIncome"
    case other = "large/other"
    case otherDeposits = "large/otherDeposit"
    case restaurantsCafe = "large/restaurantsCafe"
    case secondaryIncome = "large/secondaryIncome"
    case shopping = "large/shopping"
    case tobaccoAlcohol = "large/tobaccoAlcohol"
    case transport = "large/transport"
    case travel = "large/travel"
    case work = "large/work"
}

enum MediumCategoryEmoji: String {
    case benefits = "medium/benefits"
    case billsUtilities = "medium/billsUtilities"
    case employmentIncome = "medium/employmentIncome"
    case entertainment = "medium/entertainment"
    case financialServices = "medium/financialServices"
    case fitness = "medium/fitness"
    case groceries = "medium/groceries"
    case health = "medium/health"
    case homeFamily = "medium/homeFamily"
    case ondemandIncome = "medium/ondemandIncome"
    case other = "medium/other"
    case otherDeposits = "medium/otherDeposit"
    case restaurantsCafe = "medium/restaurantsCafe"
    case secondaryIncome = "medium/secondaryIncome"
    case shopping = "medium/shopping"
    case tobaccoAlcohol = "medium/tobaccoAlcohol"
    case transport = "medium/transport"
    case travel = "medium/travel"
    case work = "medium/work"
}


enum CountryCode: String {
    case AU = "AU"
}

enum CashDirection {
    case debit
    case credit
}

enum cAgeRange: String {
    case age18to24 = "Aged 18 to 24"
    case age25to34 = "Aged 25 to 34"
    case age35to54 = "Aged 35 to 54"
    case age55To64 = "Aged 55 to 64"
    case over65 = "Aged 65 and over"
    
    init(fromRawValue: String) {
        self = cAgeRange(rawValue: fromRawValue) ?? .over65
    }
}

enum cState: String {
    case cNSW = "New South Wales (NSW)"
    case cACT = "Australian Capital Territory (ACT)"
    case cQLD = "Queensland (NSW)"
    case cTAS = "Tasmania (TAS)"
    case cNT = "Northern Territory (NT)"
    case cSA = "South Australia (SA)"
    case cVIC = "Victoria (VIC)"
    case cWA = "Western Australia (WA)"
    
    init(fromRawValue: String) {
        self = cState(rawValue: fromRawValue) ?? .cNSW
    }
}

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
