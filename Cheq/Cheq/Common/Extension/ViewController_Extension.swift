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

protocol UIViewControllerProtocol {
    func baseScrollView()-> UIScrollView?
}



// MARK: Hide navigation bar back button title
extension UIViewController {
    
    func transparentStatusBar(_ navBar: inout UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }

    func showLogoutButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"Logout", style:.plain, target:self, action:#selector(logout))
    }
    
    func showBackButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "navBack"), style: .plain, target: self, action: #selector(back))
    }
    
    func addLogoutNavButton() {
        let nav = self.navigationItem
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        nav.setRightBarButton(logoutButton, animated: true)
    }
    
    func hideNavBar() {
        guard let nav = self.navigationController else { return }
        nav.setNavigationBarHidden(true, animated: false)
    }
    
    func hideBackTitle() {
        self.navigationItem.hidesBackButton = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }

    func showCloseButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "navClose"), style: .plain, target: self, action: #selector(closeButton))
    }

    @objc func closeButton() {
        AppNav.shared.dismissModal(self) { }
    }
    
    @objc func back() {
        AppNav.shared.dismiss(self)
    }
}

// MARK: Intercom
extension UIViewController {
    @objc func intercom(_ notification: NSNotification) {
        IntercomManager.shared.loginIntercom().done { authUser in
            IntercomManager.shared.present()
            }.catch { err in
                self.showError(err, completion: nil)
        }
    }
}

// MARK: PopupDialog wrapper
extension UIViewController {
    
    func showDecision(_ msg: String, confirmCb: (()->Void)?, cancelCb: (()->Void)?) {
        // Prepare the popup assets
        let message = msg
        let cPopup = CPopupDialog(.decision, messageBody: message, button: .ok, cancelButton: .cancel, confirm: {
            if let cb = confirmCb { cb() }
        }, cancel: {
            if let cb = cancelCb { cb() }
        })
        cPopup.present(self)
    }
    
    func showImageMessage(_ msg: String, image: String, completion: (()->Void)?) {
        let cPopup = CPopupDialog(.congrats, image: "success", messageBody: msg, button: .ok) {
            if let cb = completion { cb() }
        }
        cPopup.present(self)
    }
    
    func showMessage(_ msg: String, completion: (()->Void)?) {
        // Prepare the popup assets
        let message = msg
        let cPopup = CPopupDialog(.message, messageBody: message, button: .ok , completion: {
            if let cb = completion { cb() }
        })
        cPopup.present(self)
    }
    
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
    
    func slideUpCustomView(_ view: UIView, completion: (@escaping ()->Void)) {
       
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
        datePicker?.present(self)
    }
}

// Logout method
extension UIViewController {
    @objc func logout() {
        showDecision("You want to logout?", confirmCb: {
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
                AuthConfig.shared.activeManager.logout(authUser)
                }.done {
                    NotificationUtil.shared.notify(NotificationEvent.logout.rawValue, key: "", value: "")
                }.catch { err in
                    NotificationUtil.shared.notify(NotificationEvent.logout.rawValue, key: "", value: "")
            }
            
        }, cancelCb: nil)
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
