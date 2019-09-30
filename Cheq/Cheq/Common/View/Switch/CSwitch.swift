//
//  CSwitch.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CSwitch: UISwitch {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }
    
    func setupConfig() {
        self.onTintColor = AppConfig.shared.activeTheme.primaryColor
    }
}
