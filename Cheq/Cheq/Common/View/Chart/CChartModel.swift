//
//  ChartModel.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

enum CChartType: Int {
    case bar = 1
    case pie = 2
}

struct CChartModel {
    let title: String 
    let type: CChartType
    let dataSet: [String: Any]
    
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
