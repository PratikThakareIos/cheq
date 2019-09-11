//
//  CLabel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }

    func setupConfig() {
        self.textColor = AppConfig.shared.activeTheme.textColor
        self.font = AppConfig.shared.activeTheme.defaultFont
        self.backgroundColor = .clear
    }
}
