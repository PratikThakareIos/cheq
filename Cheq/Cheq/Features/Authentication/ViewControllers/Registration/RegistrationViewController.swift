//
//  RegistrationViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import WebKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import PromiseKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var loginLinkText: CTextView!
    @IBOutlet weak var footerText: CTextView!
    @IBOutlet weak var titleText: CLabel!
    @IBOutlet weak var descriptionText: CLabel!
    @IBOutlet weak var orText: CLabel!
    @IBOutlet weak var emailTextField: CTextField!
    @IBOutlet weak var passwordTextField: CTextField!
    @IBOutlet weak var registerButton: CButton!
    @IBOutlet weak var loginWithFacebookButton: CFacebookButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordToggleButton: CPasswordToggleButton!
    
    let viewModel = AuthenticatorViewModel()
    
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

    func setupDelegate() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.loginLinkText.delegate = self
        self.footerText.delegate = self
    }

    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.orText.font = AppConfig.shared.activeTheme.mediumFont
        self.titleText.font = AppConfig.shared.activeTheme.headerFont
        self.loginLinkText.font = AppConfig.shared.activeTheme.mediumFont
        self.loginLinkText.attributedText = viewModel.loginInText()
        self.footerText.attributedText = viewModel.conditionsAttributedText()
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
            self.navigateToNextStage()
        }.catch { [weak self] err in
            guard let self = self else { return }
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }

    @IBAction func loginWithFacebook(_ sender: Any) {
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

    @IBAction func register(_ sender: Any) {
        AppConfig.shared.showSpinner()
        viewModel.register(emailTextField.text ?? "", password: passwordTextField.text ?? "", confirmPassword: passwordTextField.text ?? "")
        .then { authUser in
            AuthConfig.shared.activeManager.setUser(authUser)
        }.done { authUser in
            self.navigateToNextStage()
        }.catch { [weak self] err in
            AppConfig.shared.hideSpinner {
                guard let self = self else { return }
                self.showError(err, completion: nil)
            }
        }
    }

    @IBAction func togglePasswordField(_ sender: Any) {
        passwordTextField.togglePasswordVisibility()
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
}

extension RegistrationViewController {
    func navigateToNextStage() {
        
        AppConfig.shared.hideSpinner {
            AppNav.shared.pushToQuestionForm(.legalName, viewController: self)
        }
        
        // check if we need to do onboarding
//        CheqAPIManager.shared.getUserDetails().done { _ in
//            // already existing registered user
//            AppConfig.shared.hideSpinner {
//                AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
//            }
//        }.catch { err in
//            AppConfig.shared.hideSpinner {
//                AppNav.shared.pushToQuestionForm(.legalName, viewController: self)
//            }
//        }
    }
}

extension RegistrationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        LoggingUtil.shared.cPrint(URL.absoluteString)
        if viewModel.isLogin(URL.absoluteString) {
            AppNav.shared.pushToViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.login.rawValue, viewController:  self)
        } else if viewModel.isSignup(URL.absoluteString) {
            AppNav.shared.pushToViewController(StoryboardName.onboarding.rawValue, storyboardId: OnboardingStoryboardId.registration.rawValue, viewController: self)
        } else if UIApplication.shared.canOpenURL(URL) {
            AppNav.shared.pushToInAppWeb(URL, viewController: self)
        }

        return false
    }
}

// MARK: UIViewControllerProtocol
extension RegistrationViewController {
    @objc override func baseScrollView() -> UIScrollView? {
        return self.scrollView
    }
}
