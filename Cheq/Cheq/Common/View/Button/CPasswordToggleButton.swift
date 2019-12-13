//
//  CToggleButton.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 This is the eye icon to show/hide while entering on a password textfield
 */
class CPasswordToggleButton: UIButton {
    
    /// boolean switch to show/hide password
    var showPassword: Bool = false
    
    /// toggle image to turn on showing of password
    let onImage: String = "showPassword"
    
    /// toggle image to turn off showing of password
    let offImage: String = "hidePassword"
    
    /// added **setupConfig** to init method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// added **setupConfig** to init method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }
    
    /// Intrinsic button height is set to be controlled by activeTheme 
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultButtonHeight)
        }
    }
    
    /// Apply styling and action triggering **didClick**
    func setupConfig() {
        self.backgroundColor = .clear
        var button = self as UIButton
        AppConfig.shared.activeTheme.roundRectButton(&button)
        self.addTarget(self, action: #selector(didClick), for: .touchUpInside)
    }
    
    /// This is the action method that toggles the image icon for show/hide password
    @objc func didClick(_ sender: UIButton) {
        showPassword = !showPassword
        // when we show password, we also show the hide button, and vice versa
        let image = showPassword ? self.offImage : self.onImage
        self.setImage(UIImage(named: image), for: .normal)
    }
}
