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
import MobileSDK
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
        hideNavBar()
        setupDelegate()
        setupUI()
        self.setupHyperlablesForLoginScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
        activeTimestamp()
        //Manish
        self.addTestAccountDetails()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func addTestAccountDetails(){
        //prateek629@yopmail.com  //cashout
        //prateek725@yopmail.com  //
        self.emailTextField.text = "prateek629@yopmail.com"
        self.passwordTextField.text = "Rdm@12345"
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
        if StringUtil.shared.isValidEmail(email) == false {
            return ValidationError.invalidEmailFormat
        }
        
        let password = self.passwordTextField.text ?? ""
        if StringUtil.shared.isValidPassword(password) == false {
            return ValidationError.invalidPasswordFormat
        }
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
            self.showError(AuthManagerError.invalidLoginFields, completion: {
                self.passwordTextField.text = ""
            })
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
        
        self.view.backgroundColor = ColorUtil.hexStringToUIColor(hex: "#4A0067")
        self.titleText.font = AppConfig.shared.activeTheme.headerBoldFont
        self.titleText.textColor = UIColor.white
        
        self.emailTextField.addPlaceholderWith(text: "Your email")
        self.passwordTextField.addPlaceholderWith(text: "Enter password")
        
        self.emailTextField.setupLeftIcon(image : UIImage(named: "img-email") ?? UIImage())
        self.passwordTextField.setupLeftIcon(image : UIImage(named: "img-lock") ?? UIImage())
        
        self.emailTextField.setShadow()
        self.passwordTextField.setShadow()
        
        self.loginButton.backgroundColor = AppConfig.shared.activeTheme.splashBgColor3
        // ColorUtil.hexStringToUIColor(hex: "#2cb4f6")
        //AppConfig.shared.activeTheme.splashBgColor3
        
        self.viewModel.screenName = .registration
        
        if self.isRootViewControllerUnderNav {
            self.lblSignUpLinkText.isHidden = true
        }
        
        self.emailTextField.keyboardType = .emailAddress
        self.passwordTextField.keyboardType = .default
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
        self.view.endEditing(true)
        
        if let error = self.validateInputs() {
            showError(error) { }
            return
        }
        
        AppConfig.shared.showSpinner()
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
                
        // whenever we successfully login, we post notification token
        viewModel.login(email, password: password).then { authUser->Promise<GetUserActionResponse> in
            //When the user opens the app the apps checks if the user has a basiq account or not
            return CheqAPIManager.shared.getUserActions()
        }.done { userActionResponse in
            
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
            
            AppConfig.shared.hideSpinner {
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
                        AppConfig.shared.showSpinner()
                        
                        AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
                            return CheqAPIManager.shared.putUser(authUser)
                        }.then { authUser in
                            AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
                        }.then { authUser in
                            AuthConfig.shared.activeManager.setUser(authUser)
                        }.done { authUser in
                            AppConfig.shared.hideSpinner {
                                AppData.shared.completingDetailsForLending = false
                                AppNav.shared.pushToMultipleChoice(.financialInstitutions, viewController: self)
                                //AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                            }
                        }.catch { err in
                            AppConfig.shared.hideSpinner {
                                 print(err)
                                 print(err.localizedDescription)
                                 self.showError(CheqAPIManagerError.errorHasOccurredOnServer) {
                                }
                            }
                        }
                        break
                    
                case  .requireMigration,.requireBankLinking, .accountReactivation, .bankLinkingUnsuccessful:
//                    UserAction: RequireMigration, RequireBankLinking, AccountReactivation
//                    LinkedInstitutionId is not null, auto-select the bank by LinkedInstitutionId
//                    LinkedInstitutionId is null, ask users to select institution from bank list

                       AppConfig.shared.hideSpinner {
                            AppData.shared.completingDetailsForLending = false
                            AppNav.shared.pushToMultipleChoice(.financialInstitutions, viewController: self)
                            //AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                       }
                       break
                    
                case .none:
                     LoggingUtil.shared.cPrint("err")
                }
            }
            
        }.catch { err in
            AppConfig.shared.hideSpinner {
                // handle err
                self.handleLoginErr(err)
            }
        }
    }
    
    
//    @IBAction func login(_ sender: Any) {
//        self.view.endEditing(true)
//
//        if let error = self.validateInputs() {
//            showError(error) { }
//            return
//        }
//
//        AppConfig.shared.showSpinner()
//
//        let email = emailTextField.text ?? ""
//        let password = passwordTextField.text ?? ""
//
//        // whenever we successfully login, we post notification token
//        viewModel.login(email, password: password).then { authUser->Promise<AuthenticationModel> in
//            return MoneySoftManager.shared.login(authUser.msCredential)
//        }.then { authModel->Promise<[FinancialAccountModel]> in
//            return MoneySoftManager.shared.getAccounts()
//        }.done { accounts in
//            AppConfig.shared.hideSpinner {
//
//                guard accounts.isEmpty == false else {
//                    AppData.shared.completingDetailsForLending = false
//                    AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
//                    return
//                }
//                let financialAccounts: [FinancialAccountModel] = accounts
//                if let disabledAccount = financialAccounts.first(where: { $0.disabled == true }) {
//                    // when we have disabled linked acccount, we need to get user
//                    // to dynamic form view and link their bank account
//                    AppData.shared.existingProviderInstitutionId = disabledAccount.providerInstitutionId ?? ""
//                    AppData.shared.existingFinancialInstitutionId = disabledAccount.financialInstitution?.financialInstitutionId ?? 0
//                    AppData.shared.disabledAccount = disabledAccount
//
//                    MoneySoftManager.shared.getInstitutions().done { institutions in
//                        AppData.shared.financialInstitutions = institutions
//                        AppData.shared.selectedFinancialInstitution = institutions.first(where: { $0.financialInstitutionId == AppData.shared.existingFinancialInstitutionId })
//                        guard let selected = AppData.shared.selectedFinancialInstitution else {
//                            AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
//                            return
//                        }
//
//                        AppData.shared.isOnboarding = false
//                        AppData.shared.migratingToNewDevice = true
//                        AppNav.shared.pushToDynamicForm(selected, viewController: self)
//                    }.catch { err in
//                        self.showError(err, completion: nil)
//                        return
//                    }
//                } else {
//                    AppData.shared.existingFinancialInstitutionId = financialAccounts.first?.financialInstitution?.financialInstitutionId ?? -1
//                    MoneySoftManager.shared.getInstitutions().done { institutions in
//                        AppData.shared.financialInstitutions = institutions
//                        AppData.shared.selectedFinancialInstitution = institutions.first(where: { $0.financialInstitutionId == AppData.shared.existingFinancialInstitutionId })
//                        // Load to dashboard
//                        AppData.shared.isOnboarding = false
//                        AppData.shared.migratingToNewDevice = false
//                        AppData.shared.completingDetailsForLending = false
//                        self.navigateToDashboard()
//                    }.catch { err in
//                        self.showError(err, completion: nil)
//                        return
//                    }
//                }
//            }
//        }.catch { err in
//            AppConfig.shared.hideSpinner {
//                // handle err
//                self.handleLoginErr(err)
//            }
//        }
//    }
    

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
            print("substring =\(strSubstring)")
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
        // AppNav.shared.presentViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.forgot.rawValue, viewController: self)
         AppNav.shared.pushToViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.forgot.rawValue, viewController: self)
//            let emailVc = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.emailVerify.rawValue, embedInNav: false)
//            AppNav.shared.pushToViewController(emailVc, from: self)
            
        } else if viewModel.isSignup(strSubstring) {
            
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
