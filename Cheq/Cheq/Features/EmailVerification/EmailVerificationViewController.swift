//
//  PasscodeViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

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
        self.sendVerificationCode()
    }
    
    func sendVerificationCode() {
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.requestEmailVerificationCode().done { _ in
            AppConfig.shared.hideSpinner {}
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err, completion: nil)
            }
        }
    }
    
    func setupDelegates() {
        self.footerText.delegate = self
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        iconImage.image = viewModel.image
        codeTextField.placeholder = viewModel.codeFieldPlaceHolder
        codeTextField.keyboardType = .numberPad
        codeTextField.reloadInputViews()
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
        let req = PutUserSingupVerificationCodeRequest(code: viewModel.code)
        // send signup confrm
        CheqAPIManager.shared.validateEmailVerificationCode(req).then { authUser in
            return AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
        }.then { authUser->Promise<AuthUser> in
            // doing PutUser for email login users after email verification
            return CheqAPIManager.shared.putUser()
        }.done { authUser in
            AppConfig.shared.hideSpinner {
                self.handleSuccessVerification()
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
               self.showError(err, completion: nil)
            }
        }
    }
 
    func handleSuccessVerification() {
        let passcodeVc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.passcode.rawValue, embedInNav: false) as! PasscodeViewController
        passcodeVc.viewModel.type = .setup
        AppNav.shared.pushToViewController(passcodeVc, from: self)
    }
}

extension EmailVerificationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        LoggingUtil.shared.cPrint(URL.absoluteString)
        if self.viewModel.isResendCodeReq(URL.absoluteString) {
            self.sendVerificationCode()
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
