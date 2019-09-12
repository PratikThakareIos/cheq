//
//  ViewController_ExtensionViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import NotificationCenter

protocol UIViewControllerProtocol {
    func baseScrollView()-> UIScrollView?
}

// MARK: PopupDialog wrapper
extension UIViewController {
    func showMessage(_ msg: String, completion: (()->Void)?) {
        // Prepare the popup assets
        let message = msg
        let cPopup = CPopupDialog(.message, messageBody: message, button: .ok , completion: {
            if let cb = completion { cb() }
        })
        cPopup.present(self)
    }
    
    func showError(_ err: Error, completion: (()->Void)?) {
        // Prepare the popup assets
        let message = err.localizedDescription
        let cPopup = CPopupDialog(.error, messageBody: message, button: .ok, completion: {
            if let cb = completion { cb() }
        })
        cPopup.present(self)
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
}

// MARK: BaseScrollView 
extension UIViewController: UIViewControllerProtocol  {

    @objc func baseScrollView()-> UIScrollView? {
        return nil
    }
}

// MARK: Navigation Helper
extension UIViewController {
    @objc func pushToViewController(_ storyboardName: String, storyboardId: String) {
        guard let nav =  self.navigationController else { return }
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        nav.pushViewController(vc, animated: true)
    }
    
    @objc func presentViewController(_ storyboardName: String, storyboardId: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
}
