//
//  CPasscodeTextField.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CPasscodeTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }
    
    func setupConfig() {
        UITextField.appearance().keyboardAppearance = .light
        self.font = AppConfig.shared.activeTheme.mediumFont
        AppConfig.shared.activeTheme.cardStyling(self, addBorder: true)
        self.textAlignment = .center
        self.leftViewMode = .never
        self.rightViewMode = .never
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight)
        }
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        NotificationUtil.shared.notify(NotificationEvent.deleteBackward.rawValue, key: "", value: "")
    }
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = self.isEnabled ? AppConfig.shared.activeTheme.altTextColor : AppConfig.shared.activeTheme.backgroundColor
        }
    }

}