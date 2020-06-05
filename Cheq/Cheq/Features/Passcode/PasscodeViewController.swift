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
        setupDelegates()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.digit1.isEnabled = true
        self.digit2.isEnabled = false
        self.digit3.isEnabled = false
        self.digit4.isEnabled = false
        self.digit1.text = ""
        self.digit2.text = ""
        self.digit3.text = ""
        self.digit4.text = ""
        self.digit1.becomeFirstResponder()
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
        self.title = self.viewModel.type.rawValue
        self.instructionLabel.font = AppConfig.shared.activeTheme.headerBoldFont
        self.instructionLabel.text = self.viewModel.instructions()
        // keep a list so we can shift as user types the focus
        self.digits = [digit1, digit2, digit3, digit4]
        
        self.scrollView.isUserInteractionEnabled = false
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
            self.digit3.isEnabled = true
            self.digit3.text = ""
            self.digit3.becomeFirstResponder()
            self.digit1.isEnabled = false
            self.digit2.isEnabled = false
            self.digit4.isEnabled = false
        }
        
        if textField == self.digit3 {
            self.digit2.isEnabled = true
            self.digit2.text = ""
            self.digit2.becomeFirstResponder()
            self.digit1.isEnabled = false
            self.digit3.isEnabled = false
            self.digit4.isEnabled = false
        }
        
        if textField == self.digit2{
            self.digit1.isEnabled = true
            self.digit1.text = ""
            self.digit1.becomeFirstResponder()
            self.digit2.isEnabled = false
            self.digit3.isEnabled = false
            self.digit4.isEnabled = false
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let text = textField.text, text.isEmpty { return }
        
        if textField == self.digit1 {
            self.digit2.isEnabled = true
            self.digit2.becomeFirstResponder()
            self.digit1.isEnabled = false
            self.digit3.isEnabled = false
            self.digit4.isEnabled = false
        }
        
        if textField == self.digit2 {
            self.digit3.isEnabled = true
            self.digit3.becomeFirstResponder()
            self.digit1.isEnabled = false
            self.digit2.isEnabled = false
            self.digit4.isEnabled = false
        }
        
        if textField == self.digit3{
            self.digit4.isEnabled = true
            self.digit4.becomeFirstResponder()
            self.digit1.isEnabled = false
            self.digit2.isEnabled = false
            self.digit3.isEnabled = false
        }
        
        if textField == self.digit4 {
            guard let digit1: String = self.digit1.text, let digit2: String = self.digit2.text, let digit3: String = self.digit3.text, let digit4: String = self.digit4.text else { return }
            viewModel.passcode = String(describing: "\(digit1)\(digit2)\(digit3)\(digit4)")
            if let error = viewModel.validate() {
                if error == .lockedOut {
                    showMessage(error.localizedDescription) {
                        // we don't let user reset passcode for now
                        // they get log out if they contiune to get passcode wrong
                        // TODO: add passcode update when we have user setting screen
                        NotificationUtil.shared.notify(NotificationEvent.logout.rawValue, key: "", value: "")
                    }
                } else {
                    showError(error) { }
                }
                return 
            }
            
            // navigate depending on scenario
            switch viewModel.type {
            case .validate:
                AppNav.shared.dismiss(self)
            case .setup:
                guard let vc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.passcode.rawValue, embedInNav: false) as? PasscodeViewController else { return }
                vc.viewModel.type = .confirm
                AppNav.shared.pushToViewController(vc, from: self)
            case .confirm:
                let _ = CKeychain.shared.setValue(CKey.passcodeLock.rawValue, value: viewModel.passcode)
                let _ = CKeychain.shared.setValue(CKey.confirmPasscodeLock.rawValue, value: viewModel.passcode)
                AppNav.shared.pushToQuestionForm(.legalName, viewController: self)
            }
        }
    }
}
