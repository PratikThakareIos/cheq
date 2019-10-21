//
//  LoginViewController.swift
//  Cheq
//
//  Created by XUWEI LIANG on 7/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import FBSDKLoginKit
import FBSDKCoreKit
import MobileSDK

class LoginViewController: RegistrationViewController {

    @IBOutlet weak var signUpLinkText: CTextView!
    @IBOutlet weak var forgotPassword: CTextView!
    @IBOutlet weak var loginButton: CButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupDelegate()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        
    }
    
    override func setupDelegate() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.forgotPassword.delegate = self
        self.signUpLinkText.delegate = self
    }
    
    override func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.orText.font = AppConfig.shared.activeTheme.mediumFont
        self.titleText.font = AppConfig.shared.activeTheme.headerFont
        self.signUpLinkText.font = AppConfig.shared.activeTheme.mediumFont
        self.signUpLinkText.attributedText = viewModel.signUpText()
        self.forgotPassword.attributedText = viewModel.forgotPasswordAttributedText()
        self.viewModel.screenName = .registration
        if self.isRootViewControllerUnderNav {
            self.signUpLinkText.isHidden = true 
        }
        
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.reloadInputViews()
        self.passwordTextField.keyboardType = .default
        self.passwordTextField.reloadInputViews()
    }
    
    func navigateToDashboard() {
        // go to dashboard board
        let _ = AppNav.shared.initTabViewController()
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
        viewModel.login(email, password: password).then { authUser in
                MoneySoftManager.shared.login(authUser.msCredential)
            }.then { authModel->Promise<[FinancialAccountModel]> in
                return MoneySoftManager.shared.getAccounts()
            }.done { accounts in
                AppConfig.shared.hideSpinner {
                    let financialAccounts: [FinancialAccountModel] = accounts
                    if let disabledAccount = financialAccounts.first(where: { $0.disabled == true }) {
                        // when we have disabled linked acccount, we need to get user
                        // to dynamic form view and link their bank account
                        AppData.shared.existingProviderInstitutionId = disabledAccount.providerInstitutionId ?? ""
                        AppData.shared.existingFinancialInstitutionId = disabledAccount.financialInstitutionId
                        MoneySoftManager.shared.getInstitutions().done { institutions in
                            AppData.shared.financialInstitutions = institutions
                            AppData.shared.selectedFinancialInstitution = institutions.first(where: { $0.financialInstitutionId == AppData.shared.existingFinancialInstitutionId && String($0.providerInstitutionId) == AppData.shared.existingProviderInstitutionId })
                            guard let selected = AppData.shared.selectedFinancialInstitution else {
                                AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                                return
                            }
                            
                            AppData.shared.isOnboarding = false
                            AppNav.shared.pushToDynamicForm(selected, viewController: self)
                        }.catch { err in
                            self.showError(err, completion: nil)
                        }
                    } else {
                        // Load to dashboard
                        AppData.shared.completingDetailsForLending = false 
                        self.navigateToDashboard()
                    }
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    // handle err
                    self.handleLoginErr(err)
                }
            }
    }
    
    func handleLoginErr(_ err: Error) {
        // special case, if getUserDetails fails, then we go through onboarding process again
        // even if you have login with firebase account
        switch err {
        case CheqAPIManagerError.onboardingRequiredFromGetUserDetails:
            self.beginOnboarding()
        default:
            self.showError(err, completion: {
                self.passwordTextField.text = ""
            })
        }
    }
    
    override func continueWithLoggedInFB(_ token: String) {
        viewModel.registerWithFBAccessToken(token).done { [weak self] authUser in
            guard let self = self else { return }
            self.navigateToDashboard()
            }.catch { [weak self] err in
                guard let self = self else { return }
                self.showError(err, completion: nil)
        }
    }
    
    @IBAction override func loginWithFacebook(_ sender: Any) {
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
}

extension LoginViewController {
    override func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        LoggingUtil.shared.cPrint(URL.absoluteString)
        if viewModel.isForgotPassword(URL.absoluteString) {
            AppNav.shared.presentViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.forgot.rawValue, viewController: self)
        } else if viewModel.isSignup(URL.absoluteString) {
            
            if isModal == false, let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else if isModal {
                AppNav.shared.dismiss(self)
            } else {
                AppNav.shared.pushToViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.registration.rawValue, viewController: self)
            }
            
        } else if UIApplication.shared.canOpenURL(URL) {
            AppNav.shared.pushToInAppWeb(URL, viewController: self)
        }
        
        return false
    }
}

// MARK: UIViewControllerProtocol
extension LoginViewController {
    @objc override func baseScrollView() -> UIScrollView? {
        return self.scrollView
    }
}
