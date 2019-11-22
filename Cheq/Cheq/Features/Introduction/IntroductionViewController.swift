//
//  EmailVerificationViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import Onfido
import PromiseKit
import MobileSDK

class IntroductionViewController: UIViewController {

    var viewModel = IntroductionViewModel() 
    @IBOutlet weak var imageViiew: UIImageView! 
    @IBOutlet weak var titleLabel: CLabel!
    @IBOutlet weak var caption: CLabel!
    @IBOutlet weak var confirmButton: CButton!
    @IBOutlet weak var secondaryButton: CButton!
    @IBOutlet weak var refreshButton: CButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        registerObservables()
        if AppData.shared.completingDetailsForLending {
            showCloseButton()
        }
        
//        autoSetupForAuthTokenIfNotLoggedIn()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }
    
    func registerObservables() {
        setupKeyboardHandling()
        NotificationCenter.default.addObserver(self, selector: #selector(self.intercom(_:)), name: NSNotification.Name(UINotificationEvent.intercom.rawValue), object: nil)
    }
    
    @IBAction func refresh() {
//        NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", object: "")
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        
        let declineReasons = IntroductionViewModel.declineReasons()
        if declineReasons.contains(self.viewModel.coordinator.type) {
            self.refreshButton.isHidden = false
        } else {
            self.refreshButton.isHidden = true
        }
        
        hideBackButton()

//        if self.viewModel.coordinator.type == .employmentTypeDeclined {
//            showCloseButton()
//        }

        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.titleLabel.font = AppConfig.shared.activeTheme.headerBoldFont
        self.titleLabel.text = self.viewModel.coordinator.type.rawValue
        self.caption.font = AppConfig.shared.activeTheme.mediumFont
        self.caption.text = self.viewModel.caption()
        self.imageViiew.image = UIImage(named: self.viewModel.imageName())
        self.secondaryButton.type = .alternate
        switch viewModel.coordinator.type {
        case .email, .enableLocation, .notification, .verifyIdentity, .employee, .employmentTypeDeclined, .creditAssessment, .jointAccount, .hasWriteOff, .noPayCycle, .monthlyPayCycle, .kycFailed, .identityConflict:
            self.secondaryButton.isHidden = false
        default:
            self.secondaryButton.isHidden = true
        }
        
        self.confirmButton.setTitle(viewModel.confirmButtonTitle(), for: .normal)
        self.secondaryButton.setTitle(viewModel.nextButtonTitle(), for: .normal)
        self.secondaryButton.setType(.alternate)
        self.refreshButton.setType(.alternate)
    }
    
    @IBAction func confirm(_ sender: Any) {
        switch viewModel.coordinator.type {
        case .setupBank:
            AppNav.shared.pushToMultipleChoice(.financialInstitutions, viewController: self)
        case .email:
            AppNav.shared.pushToQuestionForm(.legalName, viewController: self)
        case .employee:
            AppNav.shared.pushToMultipleChoice(.employmentType, viewController: self)
        case .enableLocation:
            enableLocation {
                AppNav.shared.pushToIntroduction(.notification, viewController: self)
            }
        case .notification:
            enableNotification {
                AppNav.shared.pushToQuestionForm(.companyName, viewController: self)
            }
        case .verifyIdentity:
            let qVm = QuestionViewModel()
            qVm.loadSaved()
            let req = DataHelperUtil.shared.retrieveUserDetailsKycReq()
            CheqAPIManager.shared.retrieveUserDetailsKyc(req).done { response in
                let sdkToken = response.sdkToken ?? ""
                AppData.shared.saveOnfidoSDKToken(sdkToken)
                let kycSelectDoc = KycDocType(fromRawValue: qVm.fieldValue(QuestionField.kycDocSelect))
                AppNav.shared.navigateToKYCFlow(kycSelectDoc, viewController: self)
            }.catch { err in
                self.showError(CheqAPIManagerError.unableToPerformKYCNow, completion: nil)
            }
        case .employmentTypeDeclined, .hasWriteOff, .noPayCycle, .jointAccount, .kycFailed, .monthlyPayCycle, .creditAssessment:
            LoggingUtil.shared.cPrint("Chat with us")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
        case .identityConflict:
            LoggingUtil.shared.cPrint("Confirm and change")
            // resolve kyc conflict
            AppConfig.shared.showSpinner()
            CheqAPIManager.shared.resolveNameConflict().done { authUser in
                AppConfig.shared.hideSpinner {
                    AppNav.shared.dismissModal(self)
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err, completion: nil)
                }
            }
        case .hasReachedCapacity:
            //TODO
            break
        case .hasNameConflict:
            LoggingUtil.shared.cPrint("Confirm and change")
            AppConfig.shared.showSpinner()
            CheqAPIManager.shared.resolveNameConflict().done { authUser in
                AppConfig.shared.hideSpinner {
                    AppNav.shared.dismissModal(self)
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err, completion: nil)
                }
            }
       
        }
    }

    @IBAction func secondaryButton(_ sender: Any) {
        switch viewModel.coordinator.type {
        case .setupBank:
            navigateToBankSetupLearnMore()
        case .email:
            AppNav.shared.pushToQuestionForm(.legalName, viewController: self)
        case .employee:
            AppData.shared.updateProgressAfterCompleting(ScreenName.companyAddress)
            AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
        case .enableLocation:
            AppNav.shared.pushToIntroduction(.notification, viewController: self)
        case .notification:
            AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
        case .verifyIdentity:
            // TODO : confirm this behaviour when implementing Lending 
            AppNav.shared.dismiss(self)
        case .employmentTypeDeclined, .hasWriteOff, .noPayCycle, .jointAccount, .kycFailed, .monthlyPayCycle, .creditAssessment, .identityConflict, .hasNameConflict, .hasReachedCapacity:
            LoggingUtil.shared.cPrint("Chat with us")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
        }
    }
}

extension IntroductionViewController {
    
    func openMailApp() {
        LoggingUtil.shared.cPrint("openMailApp")
        showMessage("In Progress", completion: nil)
    }
    
    func enableNotification(_ completion: @escaping ()-> Void) {
        LoggingUtil.shared.cPrint("enableNotification")
        AppDelegate.setupRemoteNotifications()
        completion()
    }
    
    // enable location then dismiss
    func enableLocation(_ completion: @escaping ()-> Void) {
        let _ = VDotManager.shared
        completion()
    }
    
    func navigateToBankSetupLearnMore() {
         LoggingUtil.shared.cPrint("navigateToBankSetupLearnMore")
    }
    
    func navigateToBankSetupFlow()  {
        LoggingUtil.shared.cPrint("navigateToBankSetupFlow")
    }
}
