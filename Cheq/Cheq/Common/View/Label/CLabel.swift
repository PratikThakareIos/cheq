//
//  CLabel.swift
//  Cheq
//
//  Created by XUWEI LIANG on 10/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CLabel is encapsulates the custom common styling of **UILabel** which is used across the app. Some scenarios uses bigger fonts, or small fonts, this is updated on the base of **CLabel** with reference to **AppConfig.shared.activeTheme**
 */
class CLabel: UILabel {

    /// adding **setupConfig** to init method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }

    /// adding **setupConfig** to init method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }

    ///  **setupConfig** encapsulates the styling logics
    func setupConfig() {
        self.textColor = AppConfig.shared.activeTheme.textColor
        self.font = AppConfig.shared.activeTheme.defaultFont
        self.backgroundColor = .clear
    }
}
