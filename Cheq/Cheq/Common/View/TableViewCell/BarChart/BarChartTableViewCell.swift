//
//  BarChartTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class BarChartTableViewCell: CTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var horizontalStackView: UIStackView! 

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.containerView.backgroundColor = .clear
        // Initialization code
        self.viewModel = BarChartTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
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
    
//    override func animate() {
//        for bar in self.horizontalStackView.arrangedSubviews {
//            let barView: BarView = bar as! BarView
//            barView.animate()
//        }
//    }
    
}
