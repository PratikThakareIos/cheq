//
//  ChartModelUtil.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 9/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import Foundation
import Charts

struct ChartModelUtil {
    static func fakeBarChartModel()-> [CChartModel] {
        let fakeData = CChartModel(title: "Comm Bank", type: .bar, dataSet: ["0" : 467.0, "1": 812.0, "2": 634.0, "3": 712.0])
        return Array(repeating:fakeData, count: 4)
    }

    static func fakePieChartModel() -> [CChartModel] {
        let fakeData = CChartModel(title: "Household", type: .pie, dataSet: ["value": 21.0, "remain": 79.0, "amount": "$644"])
        return Array(repeating:fakeData, count: 10)
    }
}

