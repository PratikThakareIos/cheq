//
//  ForgotPasswordViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 21/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

//self.forgotPasswordButton.showLoadingOnButton(self)
//self.forgotPasswordButton.hideLoadingOnButton(self)

class ForgotPasswordViewController: UIViewController {
    
    //@IBOutlet weak var titleLabel: CLabel!
    @IBOutlet weak var email: CNTextField!
    @IBOutlet weak var forgotPasswordButton: CNButton!
    var viewModel = ForgotPasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        email.becomeFirstResponder()
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func setupUI() {
        showNavBar()
        showBackButton()
        
        self.forgotPasswordButton.createShadowLayer()
        self.forgotPasswordButton.setTitle("Email me the code")

        self.email.setupLeftPadding()
        //self.email.setupLeftIcon(image : UIImage(named: "letter") ?? UIImage())
        
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        //self.titleLabel.font = AppConfig.shared.activeTheme.headerBoldFont
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        
        AppConfig.shared.addEventToFirebase(PassModuleScreen.PasswordRecovery.rawValue, FirebaseEventKey.pass_email_click.rawValue, FirebaseEventKey.pass_email_click.rawValue , FirebaseEventContentType.button.rawValue)
        
        self.view.endEditing(true)
        self.viewModel.resetEmail = email.text ?? ""
        if let error = self.viewModel.validateInput() {
            //showError(error, completion: nil)
            self.validationAlertPopup(error: error)//Manish
            return 
        }
        
        AppData.shared.forgotPasswordEmail = self.viewModel.resetEmail
        //AppConfig.shared.showSpinner()
        self.forgotPasswordButton.showLoadingOnButton(self)
        self.viewModel.forgotPassword().done { _ in
            self.forgotPasswordButton.hideLoadingOnButton(self)
            AppConfig.shared.hideSpinner {
                LoggingUtil.shared.cPrint("show email verification + new password screen")
                
                //let _ = CKeychain.shared.setValue(CKey.loggedInEmail.rawValue, value: self.viewModel.resetEmail)
                
                let vc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.emailVerify.rawValue, embedInNav: false) as! EmailVerificationViewController
                vc.viewModel = NewPasswordSetupViewModel()
                AppNav.shared.pushToViewController(vc, from: self)
            }
        }.catch { err in
            self.forgotPasswordButton.hideLoadingOnButton(self)
            AppConfig.shared.hideSpinner {
                //self.showError(err, completion: nil)
                self.validationAlertPopup(error: err)//Manish
            }
        }
    }
}


extension ForgotPasswordViewController: VerificationPopupVCDelegate {
    
    func validationAlertPopup(error:Error) {
        openPopupWith(heading: error.localizedDescription, message: "", buttonTitle: "", showSendButton: false, emoji: UIImage.init(named:"image-moreInfo"))
    }
    
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
    
    func tappedOnSendButton() {
        
    }
    
    func tappedOnCloseButton() {
        
    }
    func tappedOnLearnMoreButton() {
        
    }
}

