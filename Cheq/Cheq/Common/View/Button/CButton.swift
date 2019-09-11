//
//  CButton.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }

    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultButtonHeight)
        }
    }
    
    func setupConfig() {
        self.titleLabel?.textColor = AppConfig.shared.activeTheme.altTextColor
        self.titleLabel?.font = AppConfig.shared.activeTheme.mediumFont
        self.backgroundColor = AppConfig.shared.activeTheme.primaryColor
        var button = self
        ViewUtil.shared.roundRectButton(&button)
    }
}
