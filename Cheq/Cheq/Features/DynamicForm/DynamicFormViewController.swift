 //
//  BankSetupViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 17/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK
import PromiseKit

class DynamicFormViewController: UIViewController {

    @IBOutlet weak var sectionTitle: CLabel!
    @IBOutlet weak var questionTitle: CLabel! 
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    var built = false
    
    var viewModel = DynamicFormViewModel()
    var form:[DynamicFormInput] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.questionTitle.font = AppConfig.shared.activeTheme.headerFont
        self.questionTitle.text = self.viewModel.coordinator.viewTitle
        self.sectionTitle.text = self.viewModel.coordinator.sectionTitle
        if AppData.shared.isOnboarding {
            AppConfig.shared.progressNavBar(progress: AppData.shared.progress, viewController: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        if built { return }
        AppConfig.shared.showSpinner()
        viewModel.coordinator.loadForm().done { form in
            AppConfig.shared.hideSpinner {
                for input: DynamicFormInput in form {
                    let view = self.buildInputSubview(input)
                    self.stackView.addArrangedSubview(view)
                }
                self.built = true
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
}

 extension DynamicFormViewController {
    func buildInputSubview(_ input: DynamicFormInput)-> UIView {
        switch input.type {
        case .text:
            let textField = CTextField(frame: CGRect.zero)
            textField.placeholder = input.title
            return textField
        case .password:
            let passwordTextField = CTextField(frame: CGRect.zero)
            passwordTextField.placeholder = input.title
            passwordTextField.isSecureTextEntry = true
            return passwordTextField
        case .checkBox:
            let switchView = CSwitchWithLabel(frame: CGRect.zero, title: input.title)
            return switchView
        case .confirmButton:
            let confirmButton = CButton(frame: CGRect.zero)
            confirmButton.type = .normal
            confirmButton.setTitle(input.title, for: .normal)
            confirmButton.addTarget(self, action: #selector(confirm(_:)), for: .touchUpInside)
            return confirmButton
        case .spacer:
            let spacer = UIView(frame: CGRect.zero)
            spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
            return spacer
        }
    }
 }
 
 extension DynamicFormViewController {
    override func baseScrollView() -> UIScrollView? {
        return self.scrollView
    }
 }
 
 extension DynamicFormViewController {
    @objc func confirm(_ sender: Any) {
        LoggingUtil.shared.cPrint("confirm")
        guard AppData.shared.financialSignInForm.financialServiceId != AppData.shared.financialInstitutionsUnused else { LoggingUtil.shared.cPrint("financialSignInForm not loaded"); return }
        let form = AppData.shared.financialSignInForm
        for view in self.stackView.subviews {
            if let textField = view as? CTextField {
                let key = textField.placeholder ?? ""
                let value = textField.text ?? ""
                for prompt in form.prompts {
                    if prompt.label == key {
                        prompt.savedValue = value
                    }
                }
            }
            
            // saving value from check box 
            if let switchWithLabel = view as? CSwitchWithLabel {
                let key = switchWithLabel.titleLabel
                let value = String(switchWithLabel.switchValue())
                for prompt in form.prompts {
                    if prompt.label == key {
                        prompt.savedValue = value
                    }
                }
            }
        }
        
        // update the form with input entries 
        AppData.shared.financialSignInForm = form
        self.submitForm()
    }
    
    func submitForm() {
        
        AppConfig.shared.showSpinner()
        viewModel.coordinator.submitForm().done { success in
            AppConfig.shared.hideSpinner {
                AppData.shared.isOnboarding = false 
                AppNav.shared.pushToViewController(self.viewModel.coordinator.nextViewController(), from: self)
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
 }
