//
//  PasscodeViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import FRHyperLabel


//self.confirmButton.showLoadingOnButton(self)
//self.confirmButton.hideLoadingOnButton(self)

class EmailVerificationViewController: UIViewController {
  
    var viewModel: VerificationViewModel = EmailVerificationViewModel()
  
    @IBOutlet weak var viewTitle: CLabel!
    
    @IBOutlet weak var lblVerificationInstructions: FRHyperLabel!
    @IBOutlet weak var lblFooterText: FRHyperLabel!

    @IBOutlet weak var codeTextField: CNTextField!
    @IBOutlet weak var newPasswordField: CNTextField!
    @IBOutlet weak var confirmButton: CNButton!
    @IBOutlet weak var iconImage: UIImageView!

    //@IBOutlet weak var scrollView: UIScrollView!
    
    var invalideCodeTryCount = 0
    var isShowCodeSentPopUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if self.viewModel.type == .email {
            self.isShowCodeSentPopUp = false
            CheqAPIManager.shared.requestEmailVerificationCode().done { _ in
                   
               }.catch { err in
                   AppConfig.shared.hideSpinner {
                    //self.showError(err, completion: nil)
                    self.openPopupWith(heading: err.localizedDescription, message: "", buttonTitle: "", showSendButton: false, emoji: UIImage(named: "image-moreInfo"))
               }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //setupKeyboardHandling()
        activeTimestamp()
        self.setupHyperlables()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //removeObservables()
    }
    
    func sendVerificationCode() {
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.requestEmailVerificationCode().done { _ in
                AppConfig.shared.hideSpinner {}
                self.showVerificationCodeSentPopUp()
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    //self.showError(err, completion: nil)
                    self.openPopupWith(heading: err.localizedDescription, message: "", buttonTitle: "", showSendButton: false, emoji: UIImage(named: "image-moreInfo"))
            }
        }
    }
    
    func showVerificationCodeSentPopUp(){
        
        if (isShowCodeSentPopUp) {
            self.isShowCodeSentPopUp = false
            var email = ""
            if self.viewModel.type == .passwordReset {
               email = AppData.shared.forgotPasswordEmail
            }else{
               email = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
            }
            self.openPopupWith(heading: "Verification sent", message: "We sent a new 6 digit verification code to you at \(email)", buttonTitle: "", showSendButton: false, emoji: UIImage(named: "image-verificationSent"))
        }
    }
    
    func setupUI() {
        
        self.confirmButton.createShadowLayer()
        self.setupHyperlables()
        
        codeTextField.setShadow()
        codeTextField.setupLeftPadding()
        codeTextField.isSecureTextEntry = true
        codeTextField.addPlaceholderWith(text: viewModel.codeFieldPlaceHolder)
        codeTextField.keyboardType = .phonePad
        codeTextField.isHidden = !viewModel.showCodeField()
        codeTextField.reloadInputViews()
        
        newPasswordField.setShadow()
        newPasswordField.setupLeftPadding()
        newPasswordField.isSecureTextEntry = true
        newPasswordField.addPlaceholderWith(text: viewModel.newPasswordPlaceHolder)
        newPasswordField.isHidden = !viewModel.showNewPasswordField()
        newPasswordField.keyboardType = .default
        newPasswordField.reloadInputViews()
        
        if self.viewModel.type == .passwordReset {
            showNavBar()
            showBackButton()
            //showCloseButton()
        }
        
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        iconImage.image = viewModel.image
        
        viewTitle.text = viewModel.header
        viewTitle.font = AppConfig.shared.activeTheme.headerBoldFont
        confirmButton.setTitle(viewModel.confirmButtonTitle, for: .normal)
        
        confirmButton.setTitle(viewModel.confirmButtonTitle)
        
    }
    
    func verifyCodeAndResetPassword() {
        
        self.viewModel.code = self.codeTextField.text ?? ""
        self.viewModel.newPassword = self.newPasswordField.text ?? ""
        
        if let err = self.viewModel.validate() {
            if self.viewModel.type == .passwordReset  && (err == VerificationValidationError.invalidPasswordFormat || err == VerificationValidationError.allInputEmpty ){
                    showInvalidPasswordError(err) {
                        //self.codeTextField.text = ""
                        self.newPasswordField.text = ""
                    }
            }else{
                showError(err) {
                    //self.codeTextField.text = ""
                    self.newPasswordField.text = ""
                }
            }
            return
        }
        
        
        //AppConfig.shared.showSpinner()
        self.confirmButton.showLoadingOnButton(self)
        
        
        CheqAPIManager.shared.resetPassword(self.viewModel.code, newPassword: self.viewModel.newPassword).done { _ in
            self.confirmButton.hideLoadingOnButton(self)
            AppConfig.shared.hideSpinner {
                  self.showMessage("Password reset successfully. Please login with your new credentials") {
                     // AppNav.shared.dismissModal(self)
                    if let controllers = self.navigationController?.viewControllers, controllers.count > 0 {
                        for vc in controllers {
                           if vc is LoginVC {
                             self.navigationController?.popToViewController(vc as! LoginVC, animated: true)
                           }
                        }
                    }
                  }
              }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                LoggingUtil.shared.cPrint(err)
                self.showError(err, completion: nil)
            }
        }

    }
    
    func showInvalidPopUpView(){
        invalideCodeTryCount = invalideCodeTryCount + 1
        if invalideCodeTryCount >= 3 {
            self.openPopupWith(heading: "Resend verification", message: "You have entered the wrong verification code too many times. For your security, we will need to send you a new code", buttonTitle: "Send new verification code", showSendButton: true, emoji: UIImage(named: "image-somethingWrong"))
            return
        }else {
            self.openPopupWith(heading: "Invalid passcode, please try again", message: "", buttonTitle: "", showSendButton: false, emoji: UIImage(named: "image-moreInfo"))
            return
        }
    }
    
    func verifyCode() {
        
        //self.confirmButton.showLoadingOnButton(self)
        //self.confirmButton.hideLoadingOnButton(self)
        
        self.viewModel.code = self.codeTextField.text ?? ""
        if let _ = self.viewModel.validate() {
            self.showInvalidPopUpView()
            return
        }
        
        // TODO : verify code api call
        
        //AppConfig.shared.showSpinner()
        self.confirmButton.showLoadingOnButton(self)
        
        let req = PutUserSingupVerificationCodeRequest(code: viewModel.code)
        // send signup confrm
        CheqAPIManager.shared.validateEmailVerificationCode(req).then { authUser in
            return AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
        }.done { authUser in
                self.confirmButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    //self.handleSuccessVerification()
                    AppConfig.shared.markUserLoggedIn()
                    AppNav.shared.pushToQuestionForm(.legalName, viewController: self)
                }
        }.catch { err in
                self.confirmButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    self.showInvalidPopUpView()
                    //self.showError(err, completion: nil)
                }
        }
    }
    
    @IBAction func verify() {
        self.view.endEditing(true)
        if self.viewModel.type == .email {
            self.verifyCode()
        } else {
            self.verifyCodeAndResetPassword()
        }
    }
 
    func handleSuccessVerification() {
        let passcodeVc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.passcode.rawValue, embedInNav: false) as! PasscodeViewController
        passcodeVc.viewModel.type = .setup
        AppNav.shared.pushToViewController(passcodeVc, from: self)
    }
    
    @IBAction func btnResendCodeTapped() {
        self.view.endEditing(true)
        self.isShowCodeSentPopUp = true
        if self.viewModel.type == .passwordReset {
            self.resendCodeForSetupNewPassword()
        }else{
            self.sendVerificationCode()
        }
    }
}

extension EmailVerificationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        LoggingUtil.shared.cPrint(URL.absoluteString)
        if self.viewModel.isResendCodeReq(URL.absoluteString) {
            self.isShowCodeSentPopUp = true
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == codeTextField{
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    }
}

//MARK: - Verification popup
extension EmailVerificationViewController: VerificationPopupVCDelegate{
    
    
    func openPopupWith(heading:String?,message:String?,buttonTitle:String?,showSendButton:Bool?,emoji:UIImage?){
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: StoryboardName.Popup.rawValue, bundle: Bundle.main)
        if let popupVC = storyboard.instantiateInitialViewController() as? VerificationPopupVC{
            popupVC.delegate = self
            popupVC.heading = heading ?? ""
            popupVC.message = message ?? ""
            popupVC.buttonTitle = buttonTitle ?? ""
            popupVC.showSendButton = showSendButton ?? false
            popupVC.emojiImage = emoji ?? UIImage()
            self.present(popupVC, animated: false, completion: nil)
        }
    }
    
    func tappedOnSendButton(){
       self.invalideCodeTryCount = 0
      // self.codeTextField.text = ""
       self.isShowCodeSentPopUp = true
       self.sendVerificationCode()
    }
    
    func tappedOnCloseButton(){
        self.codeTextField.text = ""
    }
    
    func tappedOnLearnMoreButton() {
        
    }
}

extension EmailVerificationViewController {
     
    func setupHyperlables(){
        self.setupHyperlable_lblVerificationInstructions()
        self.setupHyperlable_lblFooterText()
    }
    
    func setupHyperlable_lblVerificationInstructions(){
        
        //let email = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
        var email = ""
        if self.viewModel.type == .passwordReset {
           email = AppData.shared.forgotPasswordEmail
        }else{
           email = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
        }
        
        self.lblVerificationInstructions.attributedText =  self.viewModel.instructions
        self.setAttributeOnHyperLable(lable: self.lblVerificationInstructions)
         
         //Step 2: Define a selection handler block
         let handler1 = {
             (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
             guard let strSubstring = substring else {
                 return
             }
             self.didSelectLinkWithName(strSubstring: strSubstring)
         }
         self.lblVerificationInstructions.setLinksForSubstrings(["\(email)"], withLinkHandler: handler1)
     }
     
     func setupHyperlable_lblFooterText(){
         
         self.lblFooterText.attributedText = viewModel.footerText
         self.setAttributeOnHyperLable(lable: self.lblFooterText)
         
         //Step 2: Define a selection handler block
         let handler2 = {
             (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
             guard let strSubstring = substring else {
                 return
             }
             self.didSelectLinkWithName(strSubstring: strSubstring)
         }
         self.lblFooterText.setLinksForSubstrings(["Resend"], withLinkHandler: handler2)
     }
    
     func setAttributeOnHyperLable(lable : FRHyperLabel) -> Void{
          
          var LinkColorDefault = AppConfig.shared.activeTheme.linksColor
          var LinkColorHighlight = AppConfig.shared.activeTheme.linksColor
          
          let font = AppConfig.shared.activeTheme.mediumBoldFont
        
          if (lable == self.lblVerificationInstructions){
             LinkColorDefault = UIColor(hex: "333333")
             LinkColorHighlight = UIColor(hex: "333333")
          }
        
          let linkAttributeDefault = [
              NSAttributedString.Key.foregroundColor:LinkColorDefault,
              NSAttributedString.Key.font: font
              ] as [NSAttributedString.Key : Any]
          lable.linkAttributeDefault = linkAttributeDefault
          
          let linkAttributeHighlight = [
              NSAttributedString.Key.foregroundColor:LinkColorHighlight,
              NSAttributedString.Key.font: font
              ] as [NSAttributedString.Key : Any]
          lable.linkAttributeHighlight = linkAttributeHighlight
      }
     
     func didSelectLinkWithName(strSubstring : String = ""){
         self.view.endEditing(true)
         LoggingUtil.shared.cPrint(strSubstring)
         if self.viewModel.isResendCodeReq(strSubstring) {
               self.isShowCodeSentPopUp = true
               self.sendVerificationCode()
         }
     }
}

extension EmailVerificationViewController {
    
     func resendCodeForSetupNewPassword(){
         self.view.endEditing(true)
        
         AppConfig.shared.showSpinner()
         ForgotPasswordViewModel().resetEmail = AppData.shared.forgotPasswordEmail
         ForgotPasswordViewModel().forgotPassword().done { _ in
             AppConfig.shared.hideSpinner {
                 LoggingUtil.shared.cPrint("show email verification + new password screen")
             }
            self.showVerificationCodeSentPopUp()
         }.catch { err in
             AppConfig.shared.hideSpinner {
                 self.showError(err, completion: nil)
             }
         }
     }
}


//extension EmailVerificationViewController {
//    override func baseScrollView() -> UIScrollView? {
//        return self.scrollView
//    }
//}


