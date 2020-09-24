//
//  CRadioButton.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CRadioButton is for encapsulation of styling logics which is applied across **UIButton** in the app.
 */
class CRadioButton: UIButton {
    
    /// Default button type to **normal**
    var type: CButtonType = .normal

    /// Added **setupConfig** to default init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// Added **setupConfig** to default init with coder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }
    
    /// The width is expanded by 200% for spacing because we round-cornered our button margins.
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width * 2.0, height: AppConfig.shared.activeTheme.defaultButtonHeight/2)
        }
    }
    
    /// Styling logics is kept here and re-usable.
    func setupConfig() {
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = AppConfig.shared.activeTheme.defaultFont
        self.isSelected = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
            self.layer.cornerRadius = self.frame.height/2
            self.layer.borderWidth = 1
        })
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = isSelected ? nil : AppConfig.shared.activeTheme.lightestGrayColor.cgColor
            self.backgroundColor = isSelected ? AppConfig.shared.activeTheme.primaryColor : UIColor.clear
            self.setTitleColor(isSelected ? AppConfig.shared.activeTheme.altTextColor : AppConfig.shared.activeTheme.primaryColor, for: .normal)
        }
    }
}
