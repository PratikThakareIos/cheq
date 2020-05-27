//
//  CNTextView.swift
//  Cheq
//
//  Created by Amit.Rawal on 27/05/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation
import UIKit

class CNTextView: UITextView {

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
        self.textColor = AppConfig.shared.activeTheme.placeHolderColor
        self.font = AppConfig.shared.activeTheme.mediumFont
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.layer.cornerRadius = 10
        })
        self.setShadow()
        
//        self.backgroundColor = .clear
//        self.isScrollEnabled = false
//        self.isSelectable = true
//        self.isUserInteractionEnabled = true
//        self.isEditable = true
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
