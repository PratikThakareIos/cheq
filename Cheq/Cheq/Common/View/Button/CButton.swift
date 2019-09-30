//
//  CButton.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum CButtonType {
    case normal
    case alternate
}

class CButton: UIButton {
    
    var type: CButtonType = .normal

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
        var button = self as UIButton
        AppConfig.shared.activeTheme.roundRectButton(&button)
    }
    
    func setType(_ type: CButtonType) {
        self.type = type
        switch type {
        case .normal:
            self.backgroundColor = AppConfig.shared.activeTheme.primaryColor
            self.setTitleColor(AppConfig.shared.activeTheme.altTextColor, for: .normal)
        case .alternate:
            self.titleLabel?.textColor = AppConfig.shared.activeTheme.primaryColor
            self.setTitleColor(AppConfig.shared.activeTheme.primaryColor, for: .normal)
            self.backgroundColor = .clear
        }
    }
}
