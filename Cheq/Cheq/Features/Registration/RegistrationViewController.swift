//
//  RegistrationViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 9/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import WebKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var loginLinkText: CTextView!
    @IBOutlet weak var footerText: CTextView!
    @IBOutlet weak var titleText: CLabel!
    @IBOutlet weak var descriptionText: CLabel!
    @IBOutlet weak var orText: CLabel!
    @IBOutlet weak var emailTextField: CTextField!
    @IBOutlet weak var passwordTextField: CTextField!
    @IBOutlet weak var registerButton: CButton!
    @IBOutlet weak var loginWithFacebookButton: CButton!

    let viewModel = RegistrationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupDelegate()
        setupUI()
    }

    func setupDelegate() {
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.loginLinkText.delegate = self
        self.footerText.delegate = self
    }

    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.loginWithFacebookButton.backgroundColor = AppConfig.shared.activeTheme.facebookColor
        self.orText.font = AppConfig.shared.activeTheme.mediumFont
        self.titleText.font = AppConfig.shared.activeTheme.headerFont
        self.loginLinkText.font = AppConfig.shared.activeTheme.mediumFont
        self.loginLinkText.attributedText = viewModel.loginInText()
        self.footerText.attributedText = viewModel.conditionsAttributedText()
    }

    @IBAction func loginWithFacebook(_ sender: Any) {
        showMessage("In Progress", completion: nil)
    }

    @IBAction func register(_ sender: Any) {
        AppConfig.shared.showSpinner()
        viewModel.register(emailTextField.text ?? "", password: passwordTextField.text ?? "", confirmPassword: passwordTextField.text ?? "")
        .done { authUser in
            AppConfig.shared.hideSpinner {
                
            }
        }.catch { [weak self] err in
            AppConfig.shared.hideSpinner {
                guard let self = self else { return }
                self.showError(err, completion: nil)
            }
        }
    }

    @IBAction func loginWithEmail(_ sender: Any) {

    }

    @IBAction func togglePasswordField(_ sender: Any) {

    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
}

extension RegistrationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        LoggingUtil.shared.cPrint(URL.absoluteString)
        guard let nav = self.navigationController else { return false }
        if viewModel.isLogin(URL.absoluteString) {
            let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: StoryboardId.login.rawValue)
            nav.pushViewController(loginVC, animated: true)
        } else if UIApplication.shared.canOpenURL(URL) {
            let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
            let webVC = storyboard.instantiateViewController(withIdentifier: StoryboardId.web.rawValue) as! WebViewController
            webVC.viewModel.url = URL.absoluteString
            nav.pushViewController(webVC, animated: true)
        }

        return false
    }
}
