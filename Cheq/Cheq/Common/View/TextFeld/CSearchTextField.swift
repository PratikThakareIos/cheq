//
//  CSearchTextField.swift
//  Cheq
//
//  Created by Xuwei Liang on 16/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import SearchTextField

/**
 CSearchTextField is a subclass of Pod library class **SearchTextField**
 This UI component is used when we build autocomplete dropdown list when entering residential address, company name, company address and other autocomplete text fields in the app.
 */
class CSearchTextField: SearchTextField {

    /// Added **setupConfig** to default init method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// Added **setupConfig** to default init method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfig()
    }
    
    /// SetupConfig method applies the custom styling for **SearchTextField**
    func setupConfig() {
        UITextField.appearance().keyboardAppearance = .light
        self.font = AppConfig.shared.activeTheme.mediumFont
        AppConfig.shared.activeTheme.cardStyling(self, addBorder: true)
        
        /// Added padding to the size to avoid rounded corner margins cropping the text content
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
        
        /// Modify current theme properties
        self.theme.font = AppConfig.shared.activeTheme.defaultFont
        self.theme.subtitleFontColor = AppConfig.shared.activeTheme.mediumGrayColor
        self.theme.fontColor = AppConfig.shared.activeTheme.primaryColor
        self.theme.bgColor = AppConfig.shared.activeTheme.backgroundColor
        self.theme.borderColor = AppConfig.shared.activeTheme.primaryColor
        self.theme.separatorColor = AppConfig.shared.activeTheme.primaryColor
        self.theme.cellHeight = AppConfig.shared.activeTheme.defaultButtonHeight
        self.tableCornerRadius = AppConfig.shared.activeTheme.defaultCornerRadius
        
        /// Set specific comparision options - Default: .caseInsensitive
        self.comparisonOptions = [.caseInsensitive]
        
        /// Set the max number of results. By default it's not limited
        self.maxNumberOfResults = 100
        
        /// this is critical, so we don't filter out anything from dataSource
        self.forceNoFiltering = true
        
        /// You can also limit the max height of the results list
        self.maxResultsListHeight = Int(UIScreen.main.bounds.size.height / 3)
        
        /// Handle what happens when the user picks an item. By default the title is set to the text field
        self.itemSelectionHandler = {item, itemPosition in
            let searchItem: SearchTextFieldItem = item[itemPosition]
            self.text = searchItem.title
        }
        
        self.minCharactersNumberToStartFiltering = 2
        
        self.typingStoppedDelay = AppConfig.shared.activeTheme.quickAnimationDuration
    }
    
    /// initrinsic size definition aligns with **CTextField**
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight)
        }
    }
}
