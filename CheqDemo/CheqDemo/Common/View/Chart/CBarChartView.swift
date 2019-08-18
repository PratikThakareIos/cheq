//
//  CBarChartView.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 10/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit
import Charts

class CBarChartView: BarChartView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: CChartViewProtocol
extension CBarChartView: CChartViewProtocol {
    func setupConfig() {
        self.extraBottomOffset = sharedAppConfig.activeTheme.padding
        self.legend.yOffset = sharedAppConfig.activeTheme.padding
        self.rightAxis.enabled = false
        self.xAxis.enabled = true
        self.leftAxis.enabled = false
        self.gridBackgroundColor = .clear
        self.drawBarShadowEnabled = false
        self.xAxis.labelTextColor = sharedAppConfig.activeTheme.textColor
        self.xAxis.drawAxisLineEnabled = false
        self.xAxis.drawGridLinesEnabled = false
        self.legend.textColor = sharedAppConfig.activeTheme.textColor
        self.legend.font = sharedAppConfig.activeTheme.defaultFont
        self.legend.verticalAlignment = .top
        self.xAxis.valueFormatter = CBarChartFormatter()
        self.xAxis.labelPosition =  .bottom
        self.pinchZoomEnabled = false
        self.doubleTapToZoomEnabled = false
    }

    func loadData(_ chartModel: CChartModel) {
        guard chartModel.type == .bar else { return }
        let entries: [ChartDataEntry] = chartModel.dataSet.map { (arg: (key: String, value: Any)) -> ChartDataEntry in
            let (key, value) = arg
            let k = Double(key)!
            let v = value as! Double
            return BarChartDataEntry(x: k, y: v)
        }
        let dataSet = BarChartDataSet(entries: entries, label: chartModel.title)
        dataSet.setColor(sharedAppConfig.activeTheme.textBackgroundColor.withAlphaComponent(sharedAppConfig.activeTheme.nonActiveAlpha))
        dataSet.highlightColor = sharedAppConfig.activeTheme.textBackgroundColor
        dataSet.valueTextColor = sharedAppConfig.activeTheme.textColor
        dataSet.valueFont = sharedAppConfig.activeTheme.mediumFont
        let data = BarChartData(dataSet: dataSet)
        self.data = data

        // refresh config incase we switched to diff theme 
        setupConfig()
    }
}
