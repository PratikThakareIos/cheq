//
//  CSwitch.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CSwitch is a subclass of UISwitch. All the app specific styling is encapsulated inside **CSwitch**. This is the approach across the app, any repeated styling of a type of view should be encapsulated using a subclass. This widget is used on **DynamicFormViewController** when one of the field needs to be a switch toggle. 
 */
class CSwitch: UISwitch {
    
    /// adding **setupConfig** to init by frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// adding **setupConfig** to init by coder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }
    
    /// applying styling 
    func setupConfig() {
        self.onTintColor = AppConfig.shared.activeTheme.primaryColor
    }
}
