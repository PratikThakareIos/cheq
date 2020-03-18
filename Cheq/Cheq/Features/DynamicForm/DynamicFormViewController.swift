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
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.questionTitle.font = AppConfig.shared.activeTheme.headerBoldFont
        self.questionTitle.text = self.viewModel.coordinator.viewTitle
        self.sectionTitle.text = self.viewModel.coordinator.sectionTitle
        if AppData.shared.isOnboarding {
            AppConfig.shared.progressNavBar(progress: AppData.shared.progress, viewController: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerObservables()
        activeTimestamp()
        setupKeyboardHandling()
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
    
    func registerObservables() {
          
          setupKeyboardHandling()
          
          NotificationCenter.default.addObserver(self, selector: #selector(reSubmitForm(_:)), name: NSNotification.Name(UINotificationEvent.resubmitForm.rawValue), object: nil)
    }
}

 extension DynamicFormViewController {
    func buildInputSubview(_ input: DynamicFormInput)-> UIView {
        switch input.type {
        case .text:
            let textField = CTextField(frame: CGRect.zero)
            textField.placeholder = input.title
            textField.autocapitalizationType = .none
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
        let connectingToBank = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.connecting.rawValue, embedInNav: false)
        self.present(connectingToBank, animated: true) { [weak self] in
            guard let self = self else { return }
            self.viewModel.coordinator.submitForm().done { success in
                self.checkSpendingStatus { result in
                    // dismiss "connecting to bank" viewcontroller when we are ready to move to the next screen
                    self.dismiss(animated: true) {
                        switch result {
                        case .success(_):
                            AppData.shared.isOnboarding = false
                            self.viewModel.coordinator.nextViewController()
                        case .failure(let err):
                            
                            self.showError(err, completion: nil)
                        }
                    }
                }
            }.catch { err in
                self.dismiss(animated: true) { [weak self] in
                    //Show if wrong account credentials
                    if err.localizedDescription ==  MoneySoftManagerError.wrongUserNameOrPasswordLinkableAccounts.errorDescription {
                        
                        let transactionModal: CustomSubViewPopup = UIView.fromNib()
                        transactionModal.viewModel.data = CustomPopupModel(description: "Warning attemting this with multiple time with wrong credentials might lock you out of your internet banking", imageName: "needMoreInfo", modalHeight: 350, headerTitle: "Invalid bank account credentials")
                                         transactionModal.setupUI()
                                         let popupView = CPopupView(transactionModal)

                                         popupView.show()

                    }else{
                       let connectingFailed =  AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.reTryConnecting.rawValue, embedInNav: false)
                        self?.present(connectingFailed, animated: true)
                     // self?.showError(err, completion: nil)
                    }
                }
            }
        }
    }
    
    func checkSpendingStatus(_ completion: @escaping (Result<Bool>)->Void) {
        if AppData.shared.spendingOverviewReady {
            completion(.success(true))
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                CheqAPIManager.shared.spendingStatus().done { getSpendingStatusResponse in
                    AppData.shared.spendingOverviewReady = (getSpendingStatusResponse.transactionStatus == GetSpendingStatusResponse.TransactionStatus.ready) ? true : false
                    self.checkSpendingStatus(completion)
                }.catch { err in
                    LoggingUtil.shared.cPrint(err)
                    completion(.failure(err))
                }
            }
        }
    }
 }
 extension DynamicFormViewController {
    
     @objc func reSubmitForm(_ notification: NSNotification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
              self.submitForm()
        })
       
    }

 }
