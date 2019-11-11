//
//  BarChartTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Charts

class BarChartTableViewCell: CTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    var barView = CBarChartView()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .orange
        self.containerView.backgroundColor = .clear
        // setup barView constraint
        self.barView = CBarChartView(frame: self.containerView.frame)
        self.barView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(barView)
        AutoLayoutUtil.pinToSuperview(self.barView, padding: 0.0)
        // Initialization code
        self.viewModel = BarChartTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupConfig() {
        
        // rendering of data
        let vm = self.viewModel as! BarChartTableViewCellViewModel
        self.barView.loadData(vm.chartModel())
    }
    
    override func animate() {
        self.barView.animate(yAxisDuration: sharedAppConfig.activeTheme.mediumAnimationDuration, easingOption: .easeInOutBounce)
    }
    
}
