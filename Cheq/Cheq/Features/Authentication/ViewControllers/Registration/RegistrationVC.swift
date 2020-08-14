//
//  RegistrationVC.swift
//  Cheq
//
//  Created by Manish.D on 05/03/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

import WebKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import PromiseKit
import FRHyperLabel

//self.registerButton.showLoadingOnButton(self)
//self.registerButton.hideLoadingOnButton(self)

class RegistrationVC: UIViewController {
    
    @IBOutlet weak var emailTextField: CNTextField!
    @IBOutlet weak var passwordTextField: CNTextField!
    @IBOutlet weak var lblLogin: FRHyperLabel!
    @IBOutlet weak var lblTerms: FRHyperLabel!
    @IBOutlet weak var titleText: CLabel!
    @IBOutlet weak var registerButton: CNButton!
    @IBOutlet weak var passwordToggleButton: CPasswordToggleButton!
    
    let viewModel = AuthenticatorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppData.shared.resetAllData()
        self.setupDelegate()
        hideNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        hideBackTitle()
        self.setupUI()
        
        // reset this variable when we are back on sign up / login screen
        AppData.shared.migratingToNewDevice = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
         AppConfig.shared.addEventToFirebase(PassModuleScreen.Onboarding.rawValue, FirebaseEventKey.on_signup.rawValue,FirebaseEventKey.on_signup.rawValue, FirebaseEventContentType.screen.rawValue)
        //AppConfig.shared.addEventToFirebase("", "", "", FirebaseEventContentType.screen.rawValue)
        
        self.setupUI()
        self.addNotificationsForRemoteConfig()
        RemoteConfigManager.shared.getApplicationStatusFromRemoteConfig()
    }
       
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

// MARK: Custom Methods
extension RegistrationVC {
    
    func setupDelegate() {
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func setupUI() {
        
        self.registerButton.createShadowLayer()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.emailTextField.setupLeftIcon(image : UIImage(named: "letter") ?? UIImage())
        self.passwordTextField.setupLeftIcon(image : UIImage(named: "lock") ?? UIImage())
        self.emailTextField.setShadow()
        self.passwordTextField.setShadow()
        self.viewModel.screenName = .registration
        self.setupHyperlables()
    }
    
    func continueWithLoggedInFB(_ token: String) {
        
        AppConfig.shared.showSpinner()
        viewModel.fetchProfileWithFBAccessToken().then { ()->Promise<AuthUser> in
            self.viewModel.registerWithFBAccessToken(token)
        }.then { authUser in
            AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
        }.then{ authUser in
            AuthConfig.shared.activeManager.setUser(authUser)
        }.done { authUser in
            self.beginOnboarding()
        }.catch { [weak self] err in
            guard let self = self else { return }
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
    
    func validateInputs()-> ValidationError? {
        let email = self.emailTextField.text ?? ""
        if StringUtil.shared.isValidEmail(email) == false {
            return ValidationError.invalidEmailFormat
        }
        
        let password = self.passwordTextField.text ?? ""
        if StringUtil.shared.isValidPassword(password) == false {
            return ValidationError.invalidPasswordFormat
        }
        return nil
    }
    
}

extension RegistrationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UIButton Actions
extension RegistrationVC {
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        
         AppConfig.shared.addEventToFirebase(PassModuleScreen.Onboarding.rawValue, FirebaseEventKey.on_signup_fb_click.rawValue, FirebaseEventKey.on_signup_fb_click.rawValue, FirebaseEventContentType.button.rawValue)
        
        self.view.endEditing(true)
        if AccessToken.isCurrentAccessTokenActive {
            let token = AccessToken.current?.tokenString ?? ""
            self.continueWithLoggedInFB(token)
        } else {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: fbPermissions, from: self) { [weak self] (result, error) in
                guard let self = self else { return }
                if let err = error {
                    self.showError(err, completion:nil)
                    return
                } else {
                    guard let loginResult = result, let token = loginResult.token else { self.showError(AuthManagerError.unableToRetrieveFBToken, completion: nil); return }
                    let tokenString = token.tokenString
                    self.continueWithLoggedInFB(tokenString)
                }
            }
        }
    }
    
    @IBAction func togglePasswordField(_ sender: Any) {
        passwordTextField.togglePasswordVisibility()
        
        //temp
        //AppNav.shared.pushToSetupBank(.setupBank, viewController: self)
    }
    
    @IBAction func register(_ sender: Any) {
        
          AppConfig.shared.addEventToFirebase(PassModuleScreen.Onboarding.rawValue, FirebaseEventKey.on_signup_click.rawValue, FirebaseEventKey.on_signup_click.rawValue, FirebaseEventContentType.button.rawValue)
    
        self.view.endEditing(true)
        if let error = self.validateInputs() {
            // showError(error) { } // OLD
            if error == ValidationError.invalidEmailFormat{
                validationAlertPopup(error: error, isPasswordField: false)
            } else {
                validationAlertPopup(error: error, isPasswordField: true)
            }
            return
        }

        LoggingUtil.shared.cPrint("\n>> SwaggerClientAPI.basePath = \(SwaggerClientAPI.basePath)")
        
        //self.registerButton.showLoadingOnButton(self)
        //self.registerButton.hideLoadingOnButton(self)

        //AppConfig.shared.showSpinner()
        self.registerButton.showLoadingOnButton(self)
        
        viewModel.register(emailTextField.text ?? "", password: passwordTextField.text ?? "", confirmPassword: passwordTextField.text ?? "")
            .then { authUser in
                AuthConfig.shared.activeManager.setUser(authUser)
        }.done { success in
            QuestionViewModel().clearAllSavedData()

            let email = self.emailTextField.text ?? ""
            let password = self.passwordTextField.text ?? ""

            UserDefaults.standard.set(email, forKey: UserDefaultKeys.emailID)
            UserDefaults.standard.set(password, forKey:UserDefaultKeys.password)
            
            AppData.shared.oneSignal_setExternalUserId(externalUserId: email)
            
            UserDefaults.standard.synchronize()

            self.beginOnboarding()

        }.catch { [weak self] err in
            
            //AppConfig.shared.hideSpinner {
                guard let self = self else { return }
                self.registerButton.hideLoadingOnButton(self)
                //self.showError(err, completion: nil)
                self.validationAlertPopup(error: err, isPasswordField: false)
            //}
        }
    }
}

// MARK: Navigation Methods
extension RegistrationVC {
    
    func beginOnboarding() {
        AppData.shared.isOnboarding = true
        self.registerButton.hideLoadingOnButton(self)
        AppConfig.shared.hideSpinner {
            guard let activeUser = AuthConfig.shared.activeUser else {
                self.showError(AuthManagerError.unableToRetrieveCurrentUser, completion: nil)
                return
            }
            if activeUser.type == .socialLoginEmail, activeUser.isEmailVerified == false {
                self.toEmailVerification()
            } else {
                // for Facebook emails
                //self.toPasscodeSetup()
                AppNav.shared.pushToQuestionForm(.legalName, viewController: self)
            }
        }
    }
    
    func toPasscodeSetup() {
        let passcodeVc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.passcode.rawValue, embedInNav: false)
        AppNav.shared.pushToViewController(passcodeVc, from: self)
    }
    
    func toEmailVerification() {
         
        let emailVc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.emailVerify.rawValue, embedInNav: false)
        AppNav.shared.pushToViewController(emailVc, from: self)
    }
    
}

// MARK: Hyperlable Setup
extension RegistrationVC {
    
    func setupHyperlable_lblTerms(){
        
        self.lblTerms.attributedText = viewModel.conditionsAttributedText()
        viewModel.setAttributeOnHyperLable(lable: self.lblTerms)
        
        //Step 2: Define a selection handler block
        let handler = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            guard let strSubstring = substring else {
                return
            }
            debugPrint("substring =\(strSubstring)")
            self.didSelectLinkWithName(strSubstring: strSubstring)
        }
        
        self.lblTerms.setLinksForSubstrings(["Terms of Use", "Privacy Policy"], withLinkHandler: handler)
    }
    
    func setupHyperlable_lblLogin(){
        
        self.lblLogin.attributedText = viewModel.loginInText()
        viewModel.setAttributeOnHyperLable(lable: self.lblLogin)
        
        //Step 2: Define a selection handler block
        let handler = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            guard let strSubstring = substring else {
                return
            }
             LoggingUtil.shared.cPrint("substring =\(strSubstring)")
            self.didSelectLinkWithName(strSubstring: strSubstring)
        }
        self.lblLogin.setLinksForSubstrings(["Log in"], withLinkHandler: handler)
    }
    
    func setupHyperlables(){
        self.setupHyperlable_lblTerms()
        self.setupHyperlable_lblLogin()
    }
    
    func didSelectLinkWithName(strSubstring : String = ""){
        
        self.view.endEditing(true)
        LoggingUtil.shared.cPrint(strSubstring)
        if viewModel.isForgotPassword(strSubstring) {
            AppNav.shared.presentViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.forgot.rawValue, viewController: self, embedInNav: true)
        } else if viewModel.isLogin(strSubstring) {
            //Manish
            AppNav.shared.pushToViewControllerWithAnimation(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.login.rawValue, viewController:  self)
          
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Onboarding.rawValue, FirebaseEventKey.on_signup_login_click.rawValue, FirebaseEventKey.on_signup_login_click.rawValue, FirebaseEventContentType.button.rawValue)
            
        } else if viewModel.isSignup(strSubstring) {
            AppNav.shared.pushToViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.registration.rawValue, viewController: self)
        }else{
            self.gotoSelectedLink(strSubstring : strSubstring)
        }
    }
    
    func gotoSelectedLink(strSubstring : String ){
        
        // "Terms of Use", "Private Policy"
        var strUrl = ""
        if (strSubstring == "Terms of Use"){
            strUrl = links.toc.rawValue
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Onboarding.rawValue,FirebaseEventKey.on_signup_TC.rawValue, FirebaseEventKey.on_signup_TC.rawValue, FirebaseEventContentType.button.rawValue)
                  
        }else if (strSubstring == "Privacy Policy"){
            strUrl = links.privacy.rawValue
              AppConfig.shared.addEventToFirebase(PassModuleScreen.Onboarding.rawValue, FirebaseEventKey.on_signup_PP.rawValue, FirebaseEventKey.on_signup_PP.rawValue, FirebaseEventContentType.button.rawValue)
            
        }
        
        if let url = URL.init(string: strUrl){
            if (UIApplication.shared.canOpenURL(url)) {
                AppNav.shared.pushToInAppWeb(url, viewController: self)
            }
        }
    }
    
    func gotoConnectingToBankViewController(){

         if let connectingToBank = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.connecting.rawValue, embedInNav: false) as? ConnectingToBankViewController {
             connectingToBank.modalPresentationStyle = .fullScreen
             connectingToBank.delegate = self
             connectingToBank.jobId = "13"
             self.present(connectingToBank, animated: true, completion: nil)
         }
     }
}

extension RegistrationVC : ConnectingToBankViewControllerProtocol {

    func dismissViewController(connectionJobResponse : GetConnectionJobResponse?){
        self.view.endEditing(true)
        self.showPopUpverifyingCredentialsFailed(connectionJobResponse: connectionJobResponse)
    }

    func showPopUpverifyingCredentialsFailed(connectionJobResponse : GetConnectionJobResponse?){

    }

    func manageCanSelectBankCase(canSelectBank : Bool){
        if canSelectBank {
            showNavBar()
            showBackButton()
            AppConfig.shared.progressNavBar(progress: AppData.shared.progress, viewController: self)
        }else{
            self.hideNavBar()
            self.hideBackButton()
        }
    }
}


//MARK: -  Remote config status Action
extension RegistrationVC {
    
    func addNotificationsForRemoteConfig() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goto_MaintenanceVC(_:)), name: NSNotification.Name(UINotificationEvent.showMaintenanceVC.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goto_UpdateAppVC(_:)), name: NSNotification.Name(UINotificationEvent.showUpdateAppVC.rawValue), object: nil)
    }
    
     @objc func goto_MaintenanceVC(_ notification: NSNotification){
          self.view.endEditing(true)
          AppNav.shared.presentViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.maintenanceVC.rawValue, viewController: self, embedInNav: false, animated: false)
     }
      
     @objc func goto_UpdateAppVC(_ notification: NSNotification){
          self.view.endEditing(true)
          AppNav.shared.presentViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.updateAppVC.rawValue, viewController: self, embedInNav: false, animated: false)
    }
}


// MARK:-
extension RegistrationVC : VerificationPopupVCDelegate {
    
    func validationAlertPopup(error:Error,isPasswordField:Bool) {
                
        if isPasswordField {
            openPopupWith(heading:"Please Create a Secure password with the criteria below", message: error.localizedDescription, buttonTitle: "", showSendButton: false, emoji: UIImage.init(named:"NewLock"))
          
        }
        
        let errMessage = "The email address is already in use by another account."
        
        if errMessage == error.localizedDescription {
            openPopupWith(heading: "Sorry, the email address is already in use", message:"", buttonTitle: "", showSendButton: false, emoji: UIImage.init(named:"image-moreInfo"))
        }else{
            openPopupWith(heading: error.localizedDescription, message:"", buttonTitle: "", showSendButton: false, emoji: UIImage.init(named:"image-moreInfo"))
        }
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

