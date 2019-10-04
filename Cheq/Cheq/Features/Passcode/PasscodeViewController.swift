//
//  PasscodeViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class PasscodeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var instructionLabel: CLabel!
    @IBOutlet weak var digit1: CPasscodeTextField!
    @IBOutlet weak var digit2: CPasscodeTextField!
    @IBOutlet weak var digit3: CPasscodeTextField!
    @IBOutlet weak var digit4: CPasscodeTextField!
    var viewModel = PasscodeViewModel()
    var current = 0
    var digits = [CPasscodeTextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupDelegates()
        setupUI()
    }
    
    func setupDelegates() {
        
        // Event for programmatically dismissing the keyboard anywhere
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeleteBackward), name: NSNotification.Name(NotificationEvent.deleteBackward.rawValue), object: nil)
        
        self.digit1.delegate = self
        self.digit2.delegate = self
        self.digit3.delegate = self
        self.digit4.delegate = self
        self.digit1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.digit2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.digit3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.digit4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }

    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.instructionLabel.font = AppConfig.shared.activeTheme.headerFont
        
        // dismiss when user taps outside the textfields
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        self.view.addGestureRecognizer(tapGesture)
        
        // keep a list so we can shift as user types the focus
        self.digits = [digit1, digit2, digit3, digit4]
    }
    
    @objc func dismissKey() {
        NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
    }
}

extension PasscodeViewController {
    override func baseScrollView() -> UIScrollView? {
        return self.scrollView
    }
}

extension PasscodeViewController: UITextFieldDelegate {
    
    func activeTextField()->UITextField? {
        for textField: UITextField in self.digits {
            if textField.isFirstResponder {
                return textField
            }
        }
        return nil
    }
    
    @objc func handleDeleteBackward() {
        
        guard let textField = activeTextField() else { return }
        
        if textField == self.digit4 {
            self.digit3.text = ""
            self.digit3.becomeFirstResponder()
        }
        
        if textField == self.digit3 {
            self.digit2.text = ""
            self.digit2.becomeFirstResponder()
        }
        
        if textField == self.digit2{
            self.digit1.text = ""
            self.digit1.becomeFirstResponder()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let text = textField.text, text.isEmpty { return }
        
        if textField == self.digit1 {
            self.digit2.becomeFirstResponder()
        }
        
        if textField == self.digit2 {
            self.digit3.becomeFirstResponder()
        }
        
        if textField == self.digit3{
            self.digit4.becomeFirstResponder()
        }
        
        if textField == self.digit4 {
            if let error = viewModel.validate() {
                if error == .lockedOut {
                    showMessage(error.localizedDescription) {
                        NotificationUtil.shared.notify(NotificationEvent.logout.rawValue, key: "", value: "")
                    }
                } else {
                    showError(error) { }
                }
            }
        }
    }
}
