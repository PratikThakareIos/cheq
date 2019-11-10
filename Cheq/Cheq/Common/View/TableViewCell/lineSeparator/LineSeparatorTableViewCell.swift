//
//  LineSeparatorTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 10/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class LineSeparatorTableViewCell: CTableViewCell {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var height: NSLayoutConstraint! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupConfig() {
        self.viewModel = LineSeparatorTableViewCellViewModel()
        self.lineView.backgroundColor = AppConfig.shared.activeTheme.lightGrayScaleColor
    }
}
