//
//  BarChartTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class BarChartTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "BarChartTableViewCell"
    var data: [MonthAmountStatResponse] = []
    
    
    func chartModel()->CChartModel {
        var barData: [String: Any] = [:]
        for monthAmountStat in data {
            barData[monthAmountStat.month ?? ""] = monthAmountStat.amount ?? 0.0
        }
        return CChartModel(title: "", type: .bar, dataSet: barData)
    }
}
