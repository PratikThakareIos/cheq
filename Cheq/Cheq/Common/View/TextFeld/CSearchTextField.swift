//
//  CSearchTextField.swift
//  Cheq
//
//  Created by Xuwei Liang on 16/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import SearchTextField

class CSearchTextField: SearchTextField {

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
        AppConfig.shared.activeTheme.cardStyling(self, addBorder: true)
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
        
        // Modify current theme properties
        self.theme.font = AppConfig.shared.activeTheme.defaultFont
        self.theme.fontColor = AppConfig.shared.activeTheme.primaryColor
        self.theme.bgColor = AppConfig.shared.activeTheme.backgroundColor
        self.theme.borderColor = AppConfig.shared.activeTheme.primaryColor
        self.theme.separatorColor = AppConfig.shared.activeTheme.primaryColor
        self.theme.cellHeight = AppConfig.shared.activeTheme.defaultButtonHeight
        self.tableCornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        
        // Set specific comparision options - Default: .caseInsensitive
        self.comparisonOptions = [.caseInsensitive]
        
        // Set the max number of results. By default it's not limited
        self.maxNumberOfResults = 20
        
        // You can also limit the max height of the results list
        self.maxResultsListHeight = Int(UIScreen.main.bounds.size.height / 3)
        
        // Handle what happens when the user picks an item. By default the title is set to the text field
        self.itemSelectionHandler = {item, itemPosition in
            let searchItem: SearchTextFieldItem = item[itemPosition]
            self.text = searchItem.title
        }
        
        self.minCharactersNumberToStartFiltering = 0
        
        self.typingStoppedDelay = AppConfig.shared.activeTheme.quickAnimationDuration
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight)
        }
    }
}
