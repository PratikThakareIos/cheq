//
//  CNSearchTextField.swift
//  Cheq
//
//  Created by Manish.D on 11/03/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation
import SearchTextField

/**
 CNSearchTextField is a subclass of Pod library class **SearchTextField**
 This UI component is used when we build autocomplete dropdown list when entering residential address, company name, company address and other autocomplete text fields in the app.
 */

class CNSearchTextField: SearchTextField {

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
        //AppConfig.shared.activeTheme.cardStyling(self, addBorder: true)
        
        /// Added padding to the size to avoid rounded corner margins cropping the text content
//        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height))
//        self.leftView = paddingView
//        self.leftViewMode = .always
//        self.rightView = paddingView
//        self.rightViewMode = .always
        
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
//    override open var intrinsicContentSize: CGSize {
//        get {
//            return CGSize(width: super.intrinsicContentSize.width, height: AppConfig.shared.activeTheme.defaultTextFieldHeight)
//        }
//    }
    
}

extension CNSearchTextField {

func setupLeftIcon(image : UIImage ){
    let IconView = self.createIconView()
    if let imgVw = IconView.subviews.first as? UIImageView{
        imgVw.image = image
    }
    self.leftView = IconView
    self.leftViewMode = .always
}

func setShadow() {
    //rgba(146,146,210,0.05)
    self.layer.masksToBounds = false;
    self.layer.shadowRadius  = 3.0;
    self.layer.shadowColor   = UIColor.init(r: 146, g: 146, b: 210).cgColor;
    self.layer.shadowOffset  = CGSize(width: 2.0, height: 4.0);
    self.layer.shadowOpacity = 0.05;
}

func setupLeftPadding(){
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always
}

private func createIconView() -> UIView {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.size.height))
    let image = UIImageView(frame: CGRect(x: 14, y: 0, width: 14, height: self.frame.size.height))
    image.contentMode = .scaleAspectFit
    paddingView.addSubview(image)
    return paddingView
}

func addPlaceholderWith(text: String, font: UIFont = AppConfig.shared.activeTheme.mediumFont){
     //UIColor(hex: "CDCDCD")
    let attributes = [NSAttributedString.Key.foregroundColor: AppConfig.shared.activeTheme.placeHolderColor,
                      NSAttributedString.Key.font: font]
    
    self.attributedPlaceholder = NSAttributedString(string: text,
                                                     attributes: attributes)
 }
}
