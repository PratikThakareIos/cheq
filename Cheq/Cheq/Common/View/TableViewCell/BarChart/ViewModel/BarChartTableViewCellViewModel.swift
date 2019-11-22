//
//  BarChartTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import DateToolsSwift

class BarChartTableViewCellViewModel: TableViewCellViewModelProtocol {
    var identifier: String = "BarChartTableViewCell"
    var data: [MonthAmountStatResponse] = []
    var referenceAmount: Double = 0.0
    
    func barViewModel()->[BarViewModel] {
        self.referenceAmount = findLargest()
        guard self.referenceAmount > 0.0 else { return [] }
        var barList = [BarViewModel]()
        for monthAmountStat in data {
            let bar = BarViewModel()
            bar.barBackground = AppConfig.shared.activeTheme.backgroundColor
            bar.barTintStartColor = AppConfig.shared.activeTheme.gradientSet4.first ?? .red
            bar.barTintEndColor = AppConfig.shared.activeTheme.gradientSet4.last ?? .red
            bar.amount = monthAmountStat.amount ?? 0.0
            bar.label = monthAmountStat.month ?? ""
            bar.progress = CGFloat(bar.amount / self.referenceAmount)
            
            let now = Date()
            let month = Month(rawValue: monthAmountStat.month ?? Month.Jan.rawValue) ?? Month.Jan
            if now.month == FormatterUtil.monthToInt(month) {
                bar.barViewState = .active
            }
            barList.append(bar)
        }
        return barList
    }
    
    func calculateSum()->Double {
        var total = 0.0
        for monthAmountStat in self.data {
            let amount = monthAmountStat.amount ?? 0.0
            total = total + amount
        }
        return total
    }
    
    func findLargest()->Double {
        var largest = 0.0
        for monthAmountStat in self.data {
            let amount = monthAmountStat.amount ?? 0.0
            largest = largest > amount ? largest : amount
        }
        return largest
    }
}
