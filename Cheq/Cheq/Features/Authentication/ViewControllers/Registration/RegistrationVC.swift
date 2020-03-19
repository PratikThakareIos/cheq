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
        self.setupDelegate()
        hideNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        hideBackTitle()
        self.setupUI()
        self.setupHyperlables()
        
        // reset this variable when we are back on sign up / login screen
        AppData.shared.migratingToNewDevice = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    }
    
    @IBAction func register(_ sender: Any) {
        
        self.view.endEditing(true)
        if let error = self.validateInputs() {
            showError(error) { }
            return
        }
        
        AppConfig.shared.showSpinner()
        viewModel.register(emailTextField.text ?? "", password: passwordTextField.text ?? "", confirmPassword: passwordTextField.text ?? "")
            .then { authUser in
                AuthConfig.shared.activeManager.setUser(authUser)
        }.done { authUser in
            self.beginOnboarding()
        }.catch { [weak self] err in
            AppConfig.shared.hideSpinner {
                guard let self = self else { return }
                self.showError(err, completion: nil)
            }
        }
    }
    
}

// MARK: Navigation Methods
extension RegistrationVC {
    
    func beginOnboarding() {
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
                self.toPasscodeSetup()
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
            print("substring =\(strSubstring)")
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
            AppNav.shared.presentViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.forgot.rawValue, viewController: self)
        } else if viewModel.isLogin(strSubstring) {
            //Manish
            AppNav.shared.pushToViewControllerWithAnimation(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.login.rawValue, viewController:  self)
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
        }else if (strSubstring == "Privacy Policy"){
            strUrl = links.privacy.rawValue
        }
        
        if let url = URL.init(string: strUrl){
            if (UIApplication.shared.canOpenURL(url)) {
                AppNav.shared.pushToInAppWeb(url, viewController: self)
            }
        }
    }
}
