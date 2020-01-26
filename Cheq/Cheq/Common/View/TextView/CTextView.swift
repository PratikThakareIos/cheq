//
//  CTextView.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CTextView is subclass of **UITextView** with embeded styling logics. Don't across adhoc styling logics across the app, but use subclass to encapsulate the common styling. Leaving no space for any duplicated styling logic.
 */
class CTextView: UITextView {
    
    /// adding **setupConfig** to init method
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupConfig()
    }

    /// adding **setupConfig** to init method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }

    /// setupConfig handles all the styling 
    func setupConfig() {
        self.textColor = AppConfig.shared.activeTheme.textColor
        self.font = AppConfig.shared.activeTheme.defaultFont
        self.backgroundColor = .clear
        self.isScrollEnabled = false
        self.isSelectable = true
        self.isUserInteractionEnabled = true
        self.isEditable = false 
    }
}
