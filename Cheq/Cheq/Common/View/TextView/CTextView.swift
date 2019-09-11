//
//  CTextView.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
        self.isScrollEnabled = false
        self.isSelectable = true
        self.isUserInteractionEnabled = true
        self.isEditable = false 
    }
}
