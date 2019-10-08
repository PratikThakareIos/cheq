//
//  PasscodeViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class EmailVerificationViewController: UIViewController {

    var viewModel: VerificationViewModel = EmailVerificationViewModel()
    @IBOutlet weak var viewTitle: CLabel!
    @IBOutlet weak var verificationInstructions: CLabel!
    @IBOutlet weak var codeTextField: CTextField!
    @IBOutlet weak var confirmButton: CButton!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var footerText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupDelegates()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
    }
    
    func setupDelegates() {
        self.footerText.delegate = self
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        iconImage.image = viewModel.image
        codeTextField.placeholder = viewModel.codeFieldPlaceHolder
        codeTextField.keyboardType = .numberPad
        viewTitle.text = viewModel.header
        viewTitle.font = AppConfig.shared.activeTheme.headerFont
        verificationInstructions.attributedText = viewModel.instructions
        verificationInstructions.font = AppConfig.shared.activeTheme.mediumFont
        footerText.attributedText = viewModel.footerText
        confirmButton.setTitle(viewModel.confirmButtonTitle, for: .normal)
    }
    
    @IBAction func verify() {
        self.viewModel.code = self.codeTextField.text ?? ""
        if let err = self.viewModel.validate() {
            showError(err) {
                self.codeTextField.text = ""
            }
        }
        
        // TODO : verify code api call
        AppConfig.shared.showSpinner()
        // send signup confrm
        self.handleSuccessVerification()
        
    }
    
    func handleSuccessVerification() {
        AppConfig.shared.hideSpinner {
            if AppNav.shared.passcodeExist() == false {
                let passcodeVc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.passcode.rawValue, embedInNav: false) as! PasscodeViewController
                passcodeVc.viewModel.type = .setup
                AppNav.shared.pushToViewController(passcodeVc, from: self)
            } else {
                AppNav.shared.pushToQuestionForm(.legalName, viewController: self)
            }
        }
    }
}

extension EmailVerificationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        LoggingUtil.shared.cPrint(URL.absoluteString)
        if self.viewModel.isResendCodeReq(URL.absoluteString) {
            // send signup request again
            showMessage("Email verification code re-sent.", completion: nil)
        }
        
        
        return false
    }
}

extension EmailVerificationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
}

extension EmailVerificationViewController {
    override func baseScrollView() -> UIScrollView? {
        return self.scrollView 
    }
}
