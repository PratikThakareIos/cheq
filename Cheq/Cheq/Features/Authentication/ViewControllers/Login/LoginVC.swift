//
//  LoginVC.swift
//  Cheq
//
//  Created by Manish.D on 06/03/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import FBSDKLoginKit
import FBSDKCoreKit
import FRHyperLabel

class LoginVC: UIViewController {
    
    @IBOutlet weak var lblSignUpLinkText: FRHyperLabel!
    @IBOutlet weak var loginButton: AutoSizeShadowButton!
    @IBOutlet weak var lblforgotPassword: FRHyperLabel!
    @IBOutlet weak var titleText: CLabel!
    @IBOutlet weak var emailTextField: CNTextField!
    @IBOutlet weak var passwordTextField: CNTextField!
    @IBOutlet weak var passwordToggleButton: CPasswordToggleButton!
    
    let viewModel = AuthenticatorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppData.shared.resetAllData()
        hideNavBar()
        hideBackButton()
        setupDelegate()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
        activeTimestamp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
        hideBackButton()
        setupUI()
        self.addNotificationsForRemoteConfig()
        RemoteConfigManager.shared.getApplicationStatusFromRemoteConfig()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func addTestAccountDetails(){
        //prateek629@yopmail.com  //cashout
        //prateek725@yopmail.com  "Rdm@12345" //
        //"dean+1005@cheq.com.au"  "1A@abc123" //bsb

        //self.emailTextField.text =  "md121@g.com" //"jim@g.com"//"tomtum@cheq.test" //"um31@gmail.com"//"gkk@g.com" //"way@g.com" //
        //self.passwordTextField.text =  "Tfc@12345" //"Umanga@123"
    }
    
}

// MARK: Custom Methods
extension LoginVC {
    
    //    override func continueWithLoggedInFB(_ token: String) {
    //        viewModel.registerWithFBAccessToken(token).then { [weak self] authUser in
    //            guard let self = self else { return }
    //                CheqAPIManager.shared.getUserDetails().done { authUser in
    //                    self.navigateToDashboard()
    //                }.catch { err in
    //                    self.beginOnboarding()
    //                }
    //            }.catch { [weak self] err in
    //                guard let self = self else { return }
    //                self.showError(err, completion: nil)
    //
    //            }
    //    }

    func validateInputs()-> ValidationError? {
        
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        if email.isEmpty || password.isEmpty {
            return ValidationError.associatedEmailPassword
        }
         
        if StringUtil.shared.isValidEmail(email) == false {
            return ValidationError.invalidEmailFormat
        }
        
//        let password = self.passwordTextField.text ?? ""
//        if StringUtil.shared.isValidPassword(password) == false {
//            return ValidationError.invalidPasswordFormat
//        }
    
        return nil
    }
    
    func handleLoginErr(_ err: Error) {
        // special case, if getUserDetails fails, then we go through onboarding process again
        // even if you have login with firebase account
        switch err {
        case CheqAPIManagerError.onboardingRequiredFromGetUserDetails:
            self.beginOnboarding()
        default:
            LoggingUtil.shared.cPrint(err)
            self.validationAlertPopup(error: AuthManagerError.invalidLoginFields)
            
//            self.showError(AuthManagerError.invalidLoginFields, completion: {
//                self.passwordTextField.text = ""
//            })
        }
    }
    
    func continueWithLoggedInFB(_ token: String) {
        
        AppConfig.shared.showSpinner()
        viewModel.fetchProfileWithFBAccessToken().then { ()->Promise<AuthUser> in
            self.viewModel.registerWithFBAccessToken(token)
        }.then { authUser in
            AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
        }.then{ authUser in
            AuthConfig.shared.activeManager.setUser(authUser)
        }.then { authUser in
            CheqAPIManager.shared.getUserDetails()
        }.done { authUser in
            
            AppConfig.shared.hideSpinner {
                guard authUser.email.isEmpty == false, let msUsername = authUser.msCredential[.msUsername], msUsername.isEmpty == false, let msPassword = authUser.msCredential[.msPassword], msPassword.isEmpty == false else {
                    self.beginOnboarding()
                    return
                }
                self.navigateToDashboard()
            }
        }.catch { [weak self] err in
            guard let self = self else { return }
        
            AppConfig.shared.hideSpinner {
                switch err {
                case CheqAPIManagerError.onboardingRequiredFromGetUserDetails:
                    self.beginOnboarding()
                default:
                    self.showError(err, completion: nil)
                }
            }
        }
    }
    
    func setupDelegate() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func setupUI() {
        
        self.view.backgroundColor = AppConfig.shared.activeTheme.primaryColor //ColorUtil.hexStringToUIColor(hex: "#4A0067")
        self.titleText.font = AppConfig.shared.activeTheme.headerBoldFont
        self.titleText.textColor = UIColor.white
        
        self.emailTextField.addPlaceholderWith(text: "Your email")
        self.passwordTextField.addPlaceholderWith(text: "Enter password")
        
        self.emailTextField.setupLeftIcon(image : UIImage(named: "img-email") ?? UIImage())
        self.passwordTextField.setupLeftIcon(image : UIImage(named: "img-lock") ?? UIImage())
        
        self.emailTextField.setShadow()
        self.passwordTextField.setShadow()
        
        //self.loginButton.backgroundColor = AppConfig.shared.activeTheme.splashBgColor3
        // ColorUtil.hexStringToUIColor(hex: "#2cb4f6")
        //AppConfig.shared.activeTheme.splashBgColor3
        
        self.viewModel.screenName = .registration
        
        if self.isRootViewControllerUnderNav {
            self.lblSignUpLinkText.isHidden = true
        }
        self.emailTextField.keyboardType = .emailAddress
        self.passwordTextField.keyboardType = .default
        
        self.setupHyperlablesForLoginScreen()
    }
}

extension LoginVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UIButton Actions
extension LoginVC {
    
    @IBAction  func loginWithFacebook(_ sender: Any) {
        AppConfig.shared.addEventToFirebase(PassModuleScreen.Login.rawValue, FirebaseEventKey.login_fb.rawValue, FirebaseEventKey.login_fb.rawValue, FirebaseEventContentType.button.rawValue)
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
    
 
    @IBAction func login(_ sender: Any) {
        AppConfig.shared.addEventToFirebase(PassModuleScreen.Login.rawValue, FirebaseEventKey.login_email.rawValue, FirebaseEventKey.login_email.rawValue, FirebaseEventContentType.button.rawValue)
        self.view.endEditing(true)
        
        emailTextField.text = emailTextField.text?.trim()
        passwordTextField.text = passwordTextField.text?.trim()
        
        if let error = self.validateInputs() {
            validationAlertPopup(error: error)
            return
        }
                
        self.loginButton.showLoadingOnButton(self)
       
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
                
        // whenever we successfully login, we post notification token
        viewModel.login(email, password: password).then { authUser->Promise<GetUserActionResponse> in
            //When the user opens the app the apps checks if the user has a basiq account or not
            
            UserDefaults.standard.set(email, forKey: UserDefaultKeys.emailID)
            UserDefaults.standard.set(password, forKey:UserDefaultKeys.password)
            UserDefaults.standard.synchronize()
            
            AppData.shared.oneSignal_setExternalUserId(externalUserId: email)
            AppConfig.shared.markUserLoggedIn()
            self.addLog_callingGetUserActions()
            
            return CheqAPIManager.shared.getUserActions()
            
        }.done { userActionResponse in
            
            self.addLog_EndCallingGetUserActions(strRes: "\(String(describing: userActionResponse.userAction))")
            
            /*
            The backend will return one of these condition

            RequireMigration - User has not linked their bank account with Basiq yet
            InvalidBankCredentials - Since the user has last opened their app Basiq has informed us that they are not able to access the user’s account as  they have changed their password
            ActionRequiredByBank - this is when the user needs to perform an action on their bank account before they can access their bank
            AccountReactivation- this occurs when the user has not logged in to the Cheq app and they need to “relink” their bank
            BankNotSupported - this occurs when the user’s bank is no longer supported.
            MissingAccount - this needs to call PUT v1/users to create basiq accounts
             
            if there is no issue with the user (none of these states are active) then the user proceeds to the spending dashboard as normal.
            */
            
            
            self.loginButton.hideLoadingOnButton(self)
            //AppConfig.shared.hideSpinner {
                
                LoggingUtil.shared.cPrint("\n>> SwaggerClientAPI.basePath = \(SwaggerClientAPI.basePath)")
                LoggingUtil.shared.cPrint("\n>> userActionResponse = \(userActionResponse)")

                switch (userActionResponse.userAction){
                    
                 case .genericInfo:
                        
                        AppData.shared.completingDetailsForLending = false
                        self.gotoGenericInfoVC(response : userActionResponse)
                        break
                                    
                case .categorisationInProgress:
                        
                        AppData.shared.completingDetailsForLending = false
                        self.gotoCategorisationInProgressVC(response : userActionResponse)
                        break
                    
                case ._none:

                        LoggingUtil.shared.cPrint("go to home screen")
                        // Load to dashboard
                        AppData.shared.isOnboarding = false
                        AppData.shared.migratingToNewDevice = false
                        AppData.shared.completingDetailsForLending = false
                        self.navigateToDashboard()
                        break
                    
                case .actionRequiredByBank:
                        
                        AppData.shared.completingDetailsForLending = false
                        self.gotoUserActionRequiredVC(response : userActionResponse)
                        break
                    
                case .bankNotSupported:
                    
                        AppData.shared.completingDetailsForLending = false
                        self.gotoBankNotSupportedVC(response : userActionResponse)
                        break
                    
                case .invalidCredentials:
                    
                        AppData.shared.completingDetailsForLending = false
                        AppNav.shared.pushToMultipleChoice(.financialInstitutions, viewController: self)
                        break
                    
                case .missingAccount:
                    
                        LoggingUtil.shared.cPrint("MissingAccount - this needs to call PUT v1/users to create basiq accounts")
                        
                        //AppConfig.shared.showSpinner()
                        self.loginButton.showLoadingOnButton(self)
                        
                        AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
                            return CheqAPIManager.shared.putUser(authUser)
                        }.then { authUser in
                            AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
                        }.then { authUser in
                            AuthConfig.shared.activeManager.setUser(authUser)
                        }.done { authUser in
                            self.loginButton.hideLoadingOnButton(self)
                            //AppConfig.shared.hideSpinner {
                                AppData.shared.completingDetailsForLending = false
                                AppNav.shared.pushToMultipleChoice(.financialInstitutions, viewController: self)
                                //AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                            //}
                        }.catch { err in
                            self.loginButton.hideLoadingOnButton(self)
                            //AppConfig.shared.hideSpinner {
                                  LoggingUtil.shared.cPrint(err)
                                  LoggingUtil.shared.cPrint(err.localizedDescription)
                                 self.showError(CheqAPIManagerError.errorHasOccurredOnServer) {
                                }
                            //}
                        }
                        break
                    
                case  .requireMigration,.requireBankLinking, .accountReactivation, .bankLinkingUnsuccessful:
//                    UserAction: RequireMigration, RequireBankLinking, AccountReactivation
//                    LinkedInstitutionId is not null, auto-select the bank by LinkedInstitutionId
//                    LinkedInstitutionId is null, ask users to select institution from bank list

                       self.loginButton.hideLoadingOnButton(self)
                       //AppConfig.shared.hideSpinner {
                            AppData.shared.completingDetailsForLending = false
                            AppNav.shared.pushToMultipleChoice(.financialInstitutions, viewController: self)
                            //AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                       //}
                       break
                    
                case .none:
                     LoggingUtil.shared.cPrint("err")
                }
            //}
            
        }.catch { err in
            self.loginButton.hideLoadingOnButton(self)
            //AppConfig.shared.hideSpinner {
                // handle err
                self.handleLoginErr(err)
            //}
        }
    }
    

    @IBAction func togglePasswordField(_ sender: Any) {
        passwordTextField.togglePasswordVisibility()
    }
}


// MARK: Hyperlable Setup
extension LoginVC {
    
    func setupHyperlablesForLoginScreen(){
        
        self.lblSignUpLinkText.attributedText = viewModel.signUpText()
        viewModel.setAttributeOnHyperLable(lable: self.lblSignUpLinkText)
        
        self.lblforgotPassword.attributedText = viewModel.forgotPasswordAttributedText()
        viewModel.setAttributeOnHyperLable(lable: self.lblforgotPassword)
        
        //Step 2: Define a selection handler block
        let handler = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            guard let strSubstring = substring else {
                return
            }
             LoggingUtil.shared.cPrint("substring =\(strSubstring)")
            self.didSelectLinkWithNameOnLogin(strSubstring: strSubstring)
        }
        
        //Step 3: Add link substrings
        self.lblSignUpLinkText.setLinksForSubstrings(["Register"], withLinkHandler: handler)
        self.lblforgotPassword.setLinksForSubstrings(["Forgot your password?"], withLinkHandler: handler)
    }
    
    
    func didSelectLinkWithNameOnLogin(strSubstring : String = ""){
        self.view.endEditing(true)
        LoggingUtil.shared.cPrint(strSubstring)
        if viewModel.isForgotPassword(strSubstring) {
         AppNav.shared.pushToViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.forgot.rawValue, viewController: self)
        AppConfig.shared.addEventToFirebase(PassModuleScreen.Login.rawValue, FirebaseEventKey.login_forgot_password_click.rawValue,  FirebaseEventKey.login_forgot_password_click.rawValue, FirebaseEventContentType.button.rawValue)
            
        } else if viewModel.isSignup(strSubstring) {
             AppConfig.shared.addEventToFirebase(PassModuleScreen.Login.rawValue,  FirebaseEventKey.login_signup_click.rawValue, FirebaseEventKey.login_signup_click.rawValue, FirebaseEventContentType.button.rawValue)
            
            if let nav = self.navigationController {
                //manish
                let transition: CATransition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                transition.type = CATransitionType.fade
                transition.subtype = CATransitionSubtype.fromBottom
               
                nav.view.layer.add(transition, forKey:kCATransition)
                nav.popViewController(animated: false)
            }
            
//            if isModal == false, let nav = self.navigationController {
//                //manish
//                let transition: CATransition = CATransition()
//                transition.duration = 0.5
//                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//                transition.type = CATransitionType.fade
//                transition.subtype = CATransitionSubtype.fromBottom
//
//                nav.view.layer.add(transition, forKey:kCATransition)
//                nav.popViewController(animated: false)
//
//            } else if isModal {
//                AppNav.shared.dismiss(self)
//            } else {
//
//                AppNav.shared.pushToViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.registration.rawValue, viewController: self)
//            }
            
        }else{
            
            // "Terms of Use", "Private Policy"
            var strUrl = ""
            if (strSubstring == "Terms of Use"){
                strUrl = links.toc.rawValue
            }else if (strSubstring == "Private Policy"){
                strUrl = links.privacy.rawValue
            }
            
            if let url = URL.init(string: strUrl){
                if (UIApplication.shared.canOpenURL(url)) {
                    AppNav.shared.pushToInAppWeb(url, viewController: self)
                }
            }
        }
    }
}


// MARK: Navigation Methods
extension LoginVC {
    
    func navigateToDashboard() {
        self.view.endEditing(true)
        // go to dashboard board
        var vcInfo = [String: String]()
        vcInfo[NotificationUserInfoKey.storyboardName.rawValue] = StoryboardName.main.rawValue
        vcInfo[NotificationUserInfoKey.storyboardId.rawValue] = MainStoryboardId.tab.rawValue
        NotificationUtil.shared.notify(UINotificationEvent.switchRoot.rawValue, key: NotificationUserInfoKey.vcInfo.rawValue, object: vcInfo)
    }
    
    func beginOnboarding() {
        self.view.endEditing(true)
        AppData.shared.isOnboarding = true
        self.loginButton.hideLoadingOnButton(self)
        AppConfig.shared.hideSpinner {
            
            guard let activeUser = AuthConfig.shared.activeUser else {
                //self.showError(AuthManagerError.unableToRetrieveCurrentUser, completion: nil)
                self.validationAlertPopup(error: AuthManagerError.unableToRetrieveCurrentUser)
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
        self.view.endEditing(true)
        let passcodeVc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.passcode.rawValue, embedInNav: false)
        AppNav.shared.pushToViewController(passcodeVc, from: self)
    }
    
    func toEmailVerification() {
        self.view.endEditing(true)
        let emailVc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.emailVerify.rawValue, embedInNav: false)
        AppNav.shared.pushToViewController(emailVc, from: self)
    }
    
    func gotoBankNotSupportedVC(response : GetUserActionResponse){
        self.view.endEditing(true)
        if let vc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.BankNotSupportedVC.rawValue, embedInNav: false) as? BankNotSupportedVC {
              vc.getUserActionResponse = response
              vc.modalPresentationStyle = .fullScreen
              self.present(vc, animated: true)
        }
    }
    
    func gotoCategorisationInProgressVC(response : GetUserActionResponse){
        self.view.endEditing(true)
        if let vc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.CategorisationInProgressVC.rawValue, embedInNav: false) as? CategorisationInProgressVC {
              vc.getUserActionResponse = response
              vc.modalPresentationStyle = .fullScreen
              self.present(vc, animated: true)
        }
    }
    
    func gotoUserActionRequiredVC(response : GetUserActionResponse){
        self.view.endEditing(true)
         //guard let nav =  self.navigationController else { return }
        if let vc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.userActionRequiredVC.rawValue, embedInNav: false) as? UserActionRequiredVC {
            vc.getUserActionResponse = response
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }

    func gotoGenericInfoVC(response : GetUserActionResponse){
        self.view.endEditing(true)
        if let vc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.GenericInfoVC.rawValue, embedInNav: false) as? GenericInfoVC {
              vc.getUserActionResponse = response
              vc.modalPresentationStyle = .fullScreen
              self.present(vc, animated: true)
        }
    }

    func showTransactions() {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: SalaryPaymentViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.salaryPayments.rawValue) as! SalaryPaymentViewController
        vc.isFromLendingScreen = true
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}


extension LoginVC {
    
    func addLog_callingGetUserActions(){
        let strMessage = "On Login - start calling  getUserActions - \(Date().timeStamp())"
        let strEvent = "getUserActions"
        let log = PostLogRequest(deviceId: UUID().uuidString, type: .info, message: strMessage, event: strEvent, bankName: "")
        LoggingUtil.shared.addLog(log: log)
    }
    
    func addLog_EndCallingGetUserActions(strRes : String){
        let strMessage = "On Login - End calling getUserActions - \(Date().timeStamp()) - respense \(strRes)"
        let strEvent = "getUserActions"
        let log = PostLogRequest(deviceId: UUID().uuidString, type: .info, message: strMessage, event: strEvent, bankName: "")
        LoggingUtil.shared.addLog(log: log)
    }
}

//MARK: -  Remote config status Action
extension LoginVC {
    
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


// MARK:- VerificationPopupVCDelegate
extension LoginVC : VerificationPopupVCDelegate {
    
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
