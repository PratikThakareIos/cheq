//
//  CToggleButton.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CPasswordToggleButton: UIButton {
    
    var showPassword: Bool = false
    let onImage: String = "showPassword"
    let offImage: String = "hidePassword"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultButtonHeight)
        }
    }
    
    func setupConfig() {
        self.backgroundColor = .clear
        var button = self as UIButton
        ViewUtil.shared.roundRectButton(&button)
        self.addTarget(self, action: #selector(didClick), for: .touchUpInside)
    }
    
    @objc func didClick(_ sender: UIButton) {
        showPassword = !showPassword
        // when we show password, we also show the hide button, and vice versa
        let image = showPassword ? self.offImage : self.onImage
        self.setImage(UIImage(named: image), for: .normal)
    }
}
