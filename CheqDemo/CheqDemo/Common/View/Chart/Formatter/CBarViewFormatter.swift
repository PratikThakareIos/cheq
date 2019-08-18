//
//  CBarViewFormatter.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import Charts

@objc(BarChartFormatter)
class CBarChartFormatter:NSObject,IAxisValueFormatter{
    var months = Month.allStringValues
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
}
