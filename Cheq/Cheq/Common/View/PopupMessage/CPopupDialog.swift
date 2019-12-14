//
//  CPopupDialog.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import PopupDialog

/**
 CPopupDialogTitle is enum of popup dialog titles. Use these rawValues instead of hardcoding.
 */
enum CPopupDialogTitle: String {

    case decision = "Are you sure?"
    case message = "Message"
    case error = "Error"
    
    /// When lending is sucessful, we show the congradulations dialog title
    case congrats = "Congradulations!"
}

/**
 CPopupDialogButton enum keeps track of all the button types
 */
enum CPopupDialogButton: String {
    case ok = "OK"
    case cancel = "Cancel"
}

/**
 CPopupDialog abstracts the logics for presenting a message/decision
 */
class CPopupDialog {

    /// Title of the popup dialog
    let messageTitle: String
    
    /// Message body for dialog
    let messageBody: String
    
    /// This is optional, it's the image thats part of the popup dialog. This is used for congratulations popup dialog.
    var imageName: String = ""
    
    /// Title of the confirmation button
    let buttonTitle: String
    
    /// Title of the cancel/dismissal button
    let cancelButtonTitle: String
    
    /// Popup is an instance of pod library object **PopupDialog**. With **CPopupDialog** we abstract the library we use from outside, so if we change the implementation, it won't affect how code executes the interface with **CPopupDialog**.
    var popup: PopupDialog
    
    /**
    Custom init method to conveniently setup the contents we want to populate on **CPopupDialog**. There are different flavor of custom init, this one is defaulted to have just one dismissal cancel button.
    - parameter messageTitle: title of the message title, it's **CPopupDialogTitle** because we want to ensure the String is derived from prefined enums instead of any magically defined String elsewhere in the code.
    - parameter image: image name if we want to have an image as part of the **CPopupDialog**.
    - parameter messageBody: message text for the popup dialog.
    - parameter button: button is from enum **CPopupDialogButton**, so predefined settings have to be used for consistencies across.
    - parameter completion: the completion action which is triggered by the **CancelButton** that gets added by default with this custom init method.
    */
    init(_ messageTitle: CPopupDialogTitle, image: String, messageBody: String, button: CPopupDialogButton, completion: @escaping ()->Void) {
        self.messageTitle = messageTitle.rawValue
        self.imageName = image
        self.messageBody = messageBody
        self.buttonTitle = button.rawValue
        self.cancelButtonTitle = ""
        self.popup = PopupDialog(title: self.messageTitle, message: self.messageBody, image: UIImage(named: image), buttonAlignment: .horizontal, transitionStyle: .fadeIn, preferredWidth: UIScreen.main.bounds.size.width, tapGestureDismissal: true, panGestureDismissal: false, hideStatusBar: false, completion: nil)
        setupUI(&popup)
        // Create buttons
        let buttonOne = CancelButton(title: self.buttonTitle) {
            completion()
        }
        popup.addButton(buttonOne)
    }
    
    /**
     This is a custom init method that also takes in **confirm** callback action as well **cancel** callback action.
     - parameter messageTitle: title of the message title, it's **CPopupDialogTitle** because we want to ensure the String is derived from prefined enums instead of any magically defined String elsewhere in the code.
     - parameter messageBody: message text for the popup dialog.
     - parameter button: button is from enum **CPopupDialogButton**, so predefined settings have to be used for consistencies across.
     - parameter confirm: the completion action which is triggered by the **DefaultButton** that gets added by default with this custom init method.
     - parameter cancel: the completion action which is triggered by the **CancelButton** that gets added by default with this custom init method.
     */
    init(_ messageTitle: CPopupDialogTitle, messageBody: String, button: CPopupDialogButton, cancelButton: CPopupDialogButton, confirm: @escaping ()->Void, cancel: @escaping ()-> Void) {
        self.messageTitle = messageTitle.rawValue
        self.messageBody = messageBody
        self.buttonTitle = button.rawValue
        self.cancelButtonTitle = cancelButton.rawValue
        self.popup = PopupDialog(title: self.messageTitle, message: self.messageBody, image: nil, buttonAlignment: .horizontal, transitionStyle: .fadeIn, preferredWidth: UIScreen.main.bounds.size.width * 0.8, tapGestureDismissal: true, panGestureDismissal: false, hideStatusBar: false, completion: nil)
        setupUI(&popup)
        // Create buttons
        let confirmButton = DefaultButton(title: self.buttonTitle) {
            confirm()
        }
        
        let cancelButton = CancelButton(title: self.cancelButtonTitle) {
            cancel()
        }
        popup.addButton(confirmButton)
        popup.addButton(cancelButton)
    }
    
    /**
     This is the simplest version of initialising **CPopupDialog**, we only have title, message and dismissal button.
     - parameter messageTitle: title of the message title, it's **CPopupDialogTitle** because we want to ensure the String is derived from prefined enums instead of any magically defined String elsewhere in the code.
     - parameter messageBody: message text for the popup dialog.
     - parameter button: button is enum **CPopupDialogButton**, update the enum if more button needed to be added.
     - parameter completion: this is the callback action when **CancelButton** is pressed.
     */
    init(_ messageTitle: CPopupDialogTitle, messageBody: String, button: CPopupDialogButton, completion: @escaping ()->Void) {
        self.messageTitle = messageTitle.rawValue
        self.messageBody = messageBody
        self.buttonTitle = button.rawValue
        self.cancelButtonTitle = ""
        self.popup = PopupDialog(title: self.messageTitle, message: self.messageBody)
        self.popup.transitionStyle = .fadeIn
        setupUI(&popup)
        // Create buttons
        let buttonOne = CancelButton(title: self.buttonTitle) {
            completion()
        }
        popup.addButton(buttonOne)
        
    }

    /**
     SetupUI method which encapsulates the custom styling logics of **PopupDialog** to fit the theme of the app. Notice the use of referencing styling from **AppConfig.shared.activeTheme** ensures that the the styling definitions will always be consistent.
     */
    func setupUI(_ popup: inout PopupDialog) {
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.backgroundColor      = AppConfig.shared.activeTheme.backgroundColor
        dialogAppearance.titleFont            = AppConfig.shared.activeTheme.headerFont
        dialogAppearance.titleColor           = AppConfig.shared.activeTheme.primaryColor
        dialogAppearance.titleTextAlignment   = .center
        dialogAppearance.messageFont          = AppConfig.shared.activeTheme.defaultFont
        dialogAppearance.messageColor         = AppConfig.shared.activeTheme.primaryColor
        dialogAppearance.messageTextAlignment = .left
        
        let buttonAppearance = CancelButton.appearance()
        // Cancel button
        buttonAppearance.titleFont      = AppConfig.shared.activeTheme.mediumFont
        buttonAppearance.titleColor     = AppConfig.shared.activeTheme.primaryColor
        buttonAppearance.buttonColor    = .clear
        buttonAppearance.separatorColor = AppConfig.shared.activeTheme.primaryColor
        
        let defaultButtonAppearance = DefaultButton.appearance()
        // Default button
        defaultButtonAppearance.titleFont      = AppConfig.shared.activeTheme.mediumFont
        defaultButtonAppearance.titleColor     = AppConfig.shared.activeTheme.primaryColor
        defaultButtonAppearance.buttonColor    = .clear
        defaultButtonAppearance.separatorColor = AppConfig.shared.activeTheme.primaryColor
        
        let containerAppearance = PopupDialogContainerView.appearance()
        containerAppearance.cornerRadius = Float(AppConfig.shared.activeTheme.defaultCornerRadius)
    }
    
    /// build in method which takes in the current presenting viewController and trigger the action for that viewController to present our customised popup. 
    func present(_ viewController: UIViewController) {
        viewController.present(popup, animated: true, completion: nil)
    }

}
