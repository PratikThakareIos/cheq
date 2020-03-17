//
//  CNTextField.swift
//  Cheq
//
//  Created by Manish.D on 11/03/20.
//  Copyright © 2020 Cheq. All rights reserved.
//


import UIKit

/**
CNTextField encapsulates all the custom styling logics for **UITextField** across the app.
*/
class CNTextField: UITextField {

/// added setupConfig
override init(frame: CGRect) {
    super.init(frame: frame)
    setupConfig()
}

/// added setupConfig
required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupConfig()
}

override func awakeFromNib() {
    super.awakeFromNib()
    self.font = AppConfig.shared.activeTheme.mediumFont
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
        self.layer.cornerRadius = self.frame.height/2
    })
}

/// setupConfig is the method that stylize for **CNTextField**. Because we use round-cornered rectangle, side paddings is added to create spacing between text and side margins.
func setupConfig() {
    UITextField.appearance().keyboardAppearance = .light
    self.font = AppConfig.shared.activeTheme.mediumFont
}

}

extension CNTextField {
/// method dealing ith password visibility toggling
func togglePasswordVisibility() {
    self.isSecureTextEntry.toggle()
    
    if let existingText = text, isSecureTextEntry {
        /** When toggling to secure text, all text will be purged if the user
         continues typing unless we intervene. This is prevented by first
         deleting the existing text and then recovering the original text.
         */
        deleteBackward()
        if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
            replace(textRange, withText: existingText)
        }
    }
    
    /**
     Reset the selected text range since the cursor can end up in the wrong
     position after a toggle because the text might vary in width
     */
    if let existingSelectedTextRange = selectedTextRange {
        selectedTextRange = nil
        selectedTextRange = existingSelectedTextRange
    }
}
}


extension CNTextField {

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
