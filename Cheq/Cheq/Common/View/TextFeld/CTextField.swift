//
//  CTextField.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CTextField encapsulates all the custom styling logics for **UITextField** across the app.
 */
class CTextField: UITextField {

    /// added setupConfig
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// added setupConfig
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }
    
    /// setupConfig is the method that stylize for **CTextField**. Because we use round-cornered rectangle, side paddings is added to create spacing between text and side margins.
    func setupConfig() {
        UITextField.appearance().keyboardAppearance = .light
        self.font = AppConfig.shared.activeTheme.mediumFont
        //AppConfig.shared.activeTheme.cardStyling(self, addBorder: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.layer.cornerRadius = self.frame.height/2
        })

        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }

    /// added intrinsic size definition, this can be override by autolayout constraints
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight)
        }
    }
}

extension CTextField {
    
        /// method dealing ith password visibility toggling 
        func togglePasswordVisibility() {
            self.isSecureTextEntry.toggle()
            if let existingText = text, isSecureTextEntry {
                /** When toggling to secure text, all text will be purged if the user
                 continues typing unless we intervene. This is prevented by first
                 deleting the existing text and then recovering the original text.
                 */
                deleteBackward()

                if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                    replace(textRange, withText: existingText)
                }
            }

            /**
             Reset the selected text range since the cursor can end up in the wrong
             position after a toggle because the text might vary in width
             */
            if let existingSelectedTextRange = selectedTextRange {
                selectedTextRange = nil
                selectedTextRange = existingSelectedTextRange
            }
        }
    
    func setShadow() {
        //rgba(146,146,210,0.05)
        self.layer.masksToBounds = false;
        self.layer.shadowRadius  = 3.0;
        self.layer.shadowColor   = UIColor.init(r: 146, g: 146, b: 210).cgColor;
        self.layer.shadowOffset  = CGSize(width: 2.0, height: 4.0);
        self.layer.shadowOpacity = 0.05;
    }
}
