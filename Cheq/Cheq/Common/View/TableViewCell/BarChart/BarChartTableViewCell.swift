//
//  BarChartTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 This is an implementation of bar chart which subclasses **CTableViewCell**
 */
class BarChartTableViewCell: CTableViewCell {

    /// containerView to stylize the background and margin
    @IBOutlet weak var containerView: UIView!
    
    /// bars on the barChart is embeded inside horizontal stackview
    @IBOutlet weak var horizontalStackView: UIStackView! 
 
    /// called when initiaized from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.containerView.backgroundColor = .clear
        /// Initialization code
        self.viewModel = BarChartTableViewCellViewModel()
        setupConfig()
    }

    /// Override this method to add custom logic when cell is selected. Alternatively add tap gesture to trigger a method that applies custom logic.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Whenever data is updated, call **setupConfig** again to update the bar chart 
    override func setupConfig() {
        // rendering of data
        let vm = self.viewModel as! BarChartTableViewCellViewModel
        
        for existingSubviews in horizontalStackView.arrangedSubviews {
            self.horizontalStackView.removeArrangedSubview(existingSubviews)
        }

        for barViewModel in vm.barViewModel() {
            
            let barView: BarView = UIView.fromNib()
            barView.viewModel = barViewModel
            horizontalStackView.addArrangedSubview(barView)
            barView.setupConfig()
        }
    }
}
