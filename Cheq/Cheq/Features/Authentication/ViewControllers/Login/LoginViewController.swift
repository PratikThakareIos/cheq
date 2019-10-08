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
    }
    
    func navigateToDashboard() {
        // go to dashboard board
        AppNav.shared.presentViewController(StoryboardName.spending.rawValue, storyboardId: SpendingStoryboardId.overview.rawValue, viewController: self)
    }
    
    @IBAction func login(_ sender: Any) {
        self.view.endEditing(true)
        
        if let error = self.validateInputs() {
            showError(error) { }
            return
        }
        
        AppConfig.shared.showSpinner()
        
        viewModel.login(emailTextField.text ?? "", password: passwordTextField.text ?? "").done { authUser in
            AppConfig.shared.hideSpinner {
                LoggingUtil.shared.cPrint(authUser)
                // Load to dashboard
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                if let initialController = storyboard.instantiateInitialViewController() {
                    self.show(initialController, sender: self)
                }
            }
            }.catch { [weak self] err in
                AppConfig.shared.hideSpinner {
                    guard let self = self else { return }
                    self.showError(err, completion: {
                        self.passwordTextField.text = ""
                    })
                }
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

// MARK: UIViewControllerProtocol
extension LoginViewController {
    @objc override func baseScrollView() -> UIScrollView? {
        return self.scrollView
    }
}
