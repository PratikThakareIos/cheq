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
}
