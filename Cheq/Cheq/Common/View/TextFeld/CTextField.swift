//
//  CTextField.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CTextField: UITextField {

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
        AppConfig.shared.activeTheme.cardStyling(self)

        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight)
        }
    }
}

extension CTextField {
        func togglePasswordVisibility() {
            self.isSecureTextEntry.toggle()
            if let existingText = text, isSecureTextEntry {
                /* When toggling to secure text, all text will be purged if the user
                 continues typing unless we intervene. This is prevented by first
                 deleting the existing text and then recovering the original text. */
                deleteBackward()

                if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                    replace(textRange, withText: existingText)
                }
            }

            /* Reset the selected text range since the cursor can end up in the wrong
             position after a toggle because the text might vary in width */
            if let existingSelectedTextRange = selectedTextRange {
                selectedTextRange = nil
                selectedTextRange = existingSelectedTextRange
            }
        }
}
