//
//  CPasscodeTextField.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CPasscodeTextField is a special case for textfield entry where its use for setup/entering passcode in **PasscodeViewController**. The passcode entry on **PasscodeViewController** is made up of 4 **CPasscodeTextField**. Refer to **PasswordViewController** in **common** storyboard.
 */
class CPasscodeTextField: UITextField {

    /// added **setupConfig**
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// added **setupConfig**
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }
    
    /// Styling method, this is very different to **CTextField**
    func setupConfig() {
        UITextField.appearance().keyboardAppearance = .light
        self.font = AppConfig.shared.activeTheme.mediumFont
        AppConfig.shared.activeTheme.cardStyling(self, addBorder: true)
        self.textAlignment = .center
        self.leftViewMode = .never
        self.rightViewMode = .never
    }
    
    /// intrinsic size definition
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight)
        }
    }
    
    /// when **deleteBackward** is called, a notification is sent out, **CPasscodeTextField** itself doesn't handle the handling of the bigger picture.
    override func deleteBackward() {
        super.deleteBackward()
        NotificationUtil.shared.notify(NotificationEvent.deleteBackward
            .rawValue, key: "", value: "")
    }
    
    /// enabled/disabled state have different styling on the background color 
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = self.isEnabled ? AppConfig.shared.activeTheme.altTextColor : AppConfig.shared.activeTheme.backgroundColor
        }
    }

}
