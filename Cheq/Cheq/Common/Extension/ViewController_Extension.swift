//
//  ViewController_ExtensionViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import NotificationCenter
import UDatePicker

/**
 UIViewControllerProtocol should be implement by any viewController that leverages on **setupKeyboardHandling** method to enable scrolling when keyboard shows up during data entry. This avoids keyboard blocking the view's content.
 */
protocol UIViewControllerProtocol {
    
    /// baseScrollView method returns the UIScrollView reference on viewController/ This method is used by **setupKeyboardHandling**. If we return nil, then the logic to handle keyboard display will be different, where we manually add contentInset to the viewController view instead of scrolling the current view controller
    func baseScrollView()-> UIScrollView?
}

// MARK: Hide navigation bar back button title
extension UIViewController {
    
    /// **transparentStatusBar** style nav bar to have transparent status bar
    func transparentStatusBar(_ navBar: inout UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.backgroundColor = .clear
    }

    /// style nav bar to show logout button
    func showLogoutButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"Logout", style:.plain, target:self, action:#selector(logout))
        
    }
    
    
    /// style nav bar to show back button
    func showBackButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "navBack"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    /// style to add logout button on right, it's debug purpose
    func addLogoutNavButton() {
        let nav = self.navigationItem
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        nav.setRightBarButton(logoutButton, animated: true)
    }
    
    /// show nav bar
    func showNavBar() {
        guard let nav = self.navigationController else { return }
        nav.setNavigationBarHidden(false, animated: false)
    }
    
    /// hide nav bar
    func hideNavBar() {
        guard let nav = self.navigationController else { return }
        nav.setNavigationBarHidden(true, animated: false)
    }
    
    /// hide back title text, leaving just the back arrow
    func hideBackTitle() {
        self.navigationItem.hidesBackButton = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    /// hide back button
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }

    /// show close button on the left of the nav bar
    func showCloseButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "navClose"), style: .plain, target: self, action: #selector(closeButton))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }

    /// when close button is pressed, calls **AppNav.shared.dismissModal**, which abstracts the logic behind dismissing the current view controller
    @objc func closeButton() {
        AppNav.shared.dismissModal(self) { }
    }
    
    
    /// extension method which abstracts the logic behind popping the current view controller
    @objc func back() {
        AppNav.shared.dismiss(self)
    }
}

// MARK: Intercom
extension UIViewController {
    
    /// handle presenting intercom view controller notification event
    @objc func intercom(_ notification: NSNotification) {
        AppConfig.shared.addEventToFirebase(PassModuleScreen.Profile.rawValue,FirebaseEventKey.profile_help_click.rawValue, FirebaseEventKey.profile_help_click.rawValue, FirebaseEventContentType.button.rawValue)
        IntercomManager.shared.loginIntercom().done { authUser in
            IntercomManager.shared.present()
            }.catch { err in
                self.showError(err, completion: nil)
        }
    }
}

// MARK: PopupDialog wrapper
extension UIViewController {
    
    /// wrapper to show decision popup dialog
    func showDecision(_ msg: String, confirmCb: (()->Void)?, cancelCb: (()->Void)?) {
        // Prepare the popup assets
        let message = msg
        
        /// CPopupDialog is custom class abstracting our app from whatever third party library that we are using
        let cPopup = CPopupDialog(.decision, messageBody: message, button: .ok, cancelButton: .cancel, confirm: {
            if let cb = confirmCb { cb() }
        }, cancel: {
            if let cb = cancelCb { cb() }
        })
        cPopup.present(self)
    }
    
    /// extension method to show popup with message and image altogether
    func showImageMessage(_ msg: String, image: String, completion: (()->Void)?) {
        let cPopup = CPopupDialog(.congrats, image: "success", messageBody: msg, button: .ok) {
            if let cb = completion { cb() }
        }
        cPopup.present(self)
    }
    
    
    /// extension method to simply show message with completion handler
    func showMessage(_ msg: String, completion: (()->Void)?) {
        // Prepare the popup assets
        let message = msg
        let cPopup = CPopupDialog(.message, messageBody: message, button: .ok , completion: {
            if let cb = completion { cb() }
        })
        cPopup.present(self)
    }
    
    
    /// extension method to display error
    func showError(_ err: Error, completion: (()->Void)?) {
        
        var message = ""
        // Prepare the popup assets
        if let errMessage = err.message(), errMessage.isEmpty != false  {
            message = errMessage
        } else {
            message = err.localizedDescription
        }
        
        let cPopup = CPopupDialog(.error, messageBody: message, button: .ok, completion: {
            if let cb = completion { cb() }
        })
        cPopup.present(self)
    }
    
    func showInvalidPasswordError(_ err: Error, completion: (()->Void)?) {
        
        var message = ""
        // Prepare the popup assets
        if let errMessage = err.message(), errMessage.isEmpty != false  {
            message = errMessage
        } else {
            message = err.localizedDescription
        }
        
        let cPopup = CPopupDialog(.invalidPassword, messageBody: message, button: .ok, completion: {
            if let cb = completion { cb() }
        })
        cPopup.present(self)
    }
}

// MARK: Setup Idle handling
extension UIViewController {
    func activeTimestamp() {
        let _ = CKeychain.shared.setDate(CKey.activeTime.rawValue, date: Date())
    }
}

// MARK: Keyboard handling
extension UIViewController {
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.baseScrollView() != nil, scrollView === self.baseScrollView(), scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func setupKeyboardHandling() {
        
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(notification:)))
        tapToDismiss.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapToDismiss)
        
        self.view.endEditing(true)
        if let scrollView = self.baseScrollView() {
            scrollView.contentInsetAdjustmentBehavior = .automatic
        }

        // Event for programmatically dismissing the keyboard anywhere
        NotificationCenter.default.addObserver(self, selector: #selector(dismissKeyboard(notification:)), name: NSNotification.Name(NotificationEvent.dismissKeyboard.rawValue), object: nil)

        // Events from native keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if baseScrollView() == nil {
            keyboardWillShowWithoutScrollView(notification: notification)
        } else {
            keyboardWillShowWithScrollView(notification: notification)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if baseScrollView() == nil {
            keyboardWillHideWithoutScrollView()
        } else {
            keyboardWillHideWithScrollView()
        }
    }
    
    @objc func keyboardWillHideWithoutScrollView() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillShowWithoutScrollView(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHideWithScrollView() {
        guard let scrollView = self.baseScrollView() else { return }
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillShowWithScrollView(notification: NSNotification) {
        guard let scrollView = self.baseScrollView() else { return }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset:UIEdgeInsets = scrollView.contentInset
            contentInset.bottom = keyboardSize.height
            scrollView.contentInset = contentInset
        }
    }

    @objc func dismissKeyboard(notification: NSNotification) {
        self.view.endEditing(true)
    }
}

// MARK: BaseScrollView 
extension UIViewController: UIViewControllerProtocol  {

    @objc func baseScrollView()-> UIScrollView? {
        return nil
    }
}

// MARK: Navigation Helper
extension UIViewController {

    var isRootViewControllerUnderNav: Bool {
        guard let nav = self.navigationController else { return false }
        if self == nav.viewControllers[0] {
            return true
        } else {
            return false
        }
    }
    
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}

// MARK: Date Picker
extension UIViewController {
    func showDatePicker(_ textField: UITextField, initialDate: Date, picker: UDatePicker?) {
        var datePicker = picker
        if datePicker == nil {
            datePicker = UDatePicker(frame: view.frame, willDisappear: { date in
                if date != nil {
                    LoggingUtil.shared.cPrint("select date \(String(describing: date))")
                    textField.text = date?.format(with: TestUtil.shared.dobFormatStyle())
                }
            })
        }
        datePicker?.picker.date = initialDate
        datePicker?.picker.datePicker.maximumDate = initialDate
        datePicker?.present(self)
    }
}

// Logout method
extension UIViewController {
    @objc func logout() {
       
        AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
                       AuthConfig.shared.activeManager.logout(authUser)
                       }.done {
                           NotificationUtil.shared.notify(NotificationEvent.logout.rawValue, key: "", value: "")
                       }.catch { err in
                           NotificationUtil.shared.notify(NotificationEvent.logout.rawValue, key: "", value: "")
        }
    
//        showDecision("You want to logout?", confirmCb: {
//            AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
//                AuthConfig.shared.activeManager.logout(authUser)
//                }.done {
//                    NotificationUtil.shared.notify(NotificationEvent.logout.rawValue, key: "", value: "")
//                }.catch { err in
//                    NotificationUtil.shared.notify(NotificationEvent.logout.rawValue, key: "", value: "")
//            }
//
//        }, cancelCb: nil)
    }
    
    @objc func tapToDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

//demo helper method for Development/DEMO only
extension UIViewController {
    @objc func autoSetupForAuthTokenIfNotLoggedIn() {
        AppConfig.shared.showSpinner()
        AuthConfig.shared.activeManager.getCurrentUser().done { _ in
            AppConfig.shared.hideSpinner { }
        }.catch { err in
            self.autoSetup()
        }
    }
    
    func autoSetup() {
        TestUtil.shared.autoSetupRegisteredCheqAccount().done { authUser in
            AppConfig.shared.hideSpinner {
                self.showMessage("initial setup done!", completion: nil)
            }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err, completion: nil)
                }
        }
    }
}

// MARK: Clear observables
extension UIViewController {
    @objc func removeObservables() {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: reload table without tableview scrolling
extension UIViewController {
    func reloadTableView(_ tableView: UITableView) {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.layoutSubviews()
        tableView.setContentOffset(contentOffset, animated: false)
        
    }
}


//MARK: How to set left-aligned title on the iOS navigation item
extension UIViewController
{
    func setLeftAlignedNavigationItemTitle(text: String,
                                           color: UIColor,
                                           margin left: CGFloat)
    {
        let titleLabel = UILabel()
        titleLabel.textColor = color
        titleLabel.text = text
        titleLabel.textAlignment = .left
        titleLabel.font = AppConfig.shared.activeTheme.headerBoldFont
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.navigationItem.titleView = titleLabel
        
        guard let containerView = self.navigationItem.titleView?.superview else { return }
        
        // NOTE: This always seems to be 0. Huh??
        let leftBarItemWidth = self.navigationItem.leftBarButtonItems?.reduce(0, { $0 + $1.width })
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor,
                                             constant: (leftBarItemWidth ?? 0) + left),
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        ])
    }
}
