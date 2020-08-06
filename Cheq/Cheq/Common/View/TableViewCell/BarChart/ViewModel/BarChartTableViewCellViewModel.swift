//
//  BarChartTableViewCellViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import DateToolsSwift

/**
 ViewModel for **BarChartTableViewCell**
 */
class BarChartTableViewCellViewModel: TableViewCellViewModelProtocol {
    
    /// re-use identifier for **BarChartTableViewCell**
    var identifier: String = "BarChartTableViewCell"
    
    /// data is array of **MonthAmountStatResponse**, each **MonthAmountStatResponse** represents a bar on the bar chart
    var data: [MonthAmountStatResponse] = []
    
    /// We use this amount as a reference as a divider for monthAmount. In the current implementation, the referenceAmount is the largest amount from **MonthAmountStatResponse** array.
    var referenceAmount: Double = 0.0
    
    /**
     barViewModel() returns Array of **BarViewModel** with calculated viewModels
     */
    func barViewModel()->[BarViewModel] {
        /// referenceAmount is largest instead of the total, so the bars are closer in height
        self.referenceAmount = findLargest()
        guard self.referenceAmount > 0.0 else { return [BarViewModel]() }
        var barList = [BarViewModel]()
        for monthAmountStat in data.reversed() {
            let amount = abs(monthAmountStat.amount ?? 0.0)
            let bar = BarViewModel()
            bar.barBackground = AppConfig.shared.activeTheme.backgroundColor
            bar.barTintStartColor = AppConfig.shared.activeTheme.gradientSet4.first ?? .red
            bar.barTintEndColor = AppConfig.shared.activeTheme.gradientSet4.last ?? .red
            bar.amount = amount
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
    
    /// helper method to sum up all the month amount
    func calculateSum()->Double {
        var total = 0.0
        for monthAmountStat in self.data {
            let amount = abs(monthAmountStat.amount ?? 0.0)
            total = total + amount
        }
        return total
    }
    
    /// helper method to find the largest amount from **data**
    func findLargest()->Double {
        var largest = 1.0
        for monthAmountStat in self.data {
            let amount = abs(monthAmountStat.amount ?? 0.0)
            largest = largest > amount ? largest : amount
        }
        return largest
    }
}
