//
//  CFacebookButton.swift
//  Cheq
//
//  Created by Xuwei Liang on 13/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CFacebookButton is not a common styling for **UIButton**. So it is separated from **CButton** logics.
 */
class CFacebookButton: CButton {

    /// Added setupConfig
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// Added setupConfig
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }

    /// Styling logics is encapsulated inside **setupConfig**
    override func setupConfig() {
        super.setupConfig()
        self.backgroundColor = .clear
        self.setTitleColor(AppConfig.shared.activeTheme.facebookColor, for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = AppConfig.shared.activeTheme.facebookColor.cgColor
        guard let fbIcon = UIImage(named: fbIconImage) else { return }
        self.setImage(fbIcon, for: .normal)
        let fbIconSpacing = fbIcon.size.width
         self.titleEdgeInsets = UIEdgeInsets(top: 0, left: fbIconSpacing, bottom: 0, right: 0)
    }
}
