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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
    }
    
    func setupUI() {
        hideBackButton()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.titleLabel.font = AppConfig.shared.activeTheme.headerFont
        self.titleLabel.text = self.viewModel.type.rawValue
        self.caption.font = AppConfig.shared.activeTheme.mediumFont
        self.caption.text = self.viewModel.caption()
        self.imageViiew.image = UIImage(named: self.viewModel.imageName())
        self.secondaryButton.type = .alternate
        switch viewModel.type {
        case .setupBank, .email, .enableLocation, .notification, .verifyIdentity, .employee:
            self.secondaryButton.isHidden = false
//        default:
//            self.secondaryButton.isHidden = true
        }
        
        self.confirmButton.setTitle(viewModel.confirmButtonTitle(), for: .normal)
        self.secondaryButton.setTitle(viewModel.nextButtonTitle(), for: .normal)
        self.secondaryButton.setType(.alternate)
    }
    
    @IBAction func confirm(_ sender: Any) {
        switch viewModel.type {
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = TestUtil.shared.dobFormatStyle()
            let dob = dateFormatter.date(from: qVm.fieldValue(.dateOfBirth)) ?? Date()
            CheqAPIManager.shared.retrieveUserDetailsKyc(firstName: qVm.fieldValue(.firstname), lastName: qVm.fieldValue(.lastname), residentialAddress: qVm.fieldValue(.residentialAddress), dateOfBirth: dob).done { response in
                let sdkToken = response.sdkToken ?? ""
                AppData.shared.saveOnfidoSDKToken(sdkToken)
                AppNav.shared.navigateToKYCFlow(self)
            }.catch { err in
                self.showError(CheqAPIManagerError.unableToPerformKYCNow, completion: nil)
            }
        }
    }

    @IBAction func secondaryButton(_ sender: Any) {
        switch viewModel.type {
        case .setupBank:
            navigateToBankSetupLearnMore()
        case .email:
            AppNav.shared.pushToQuestionForm(.legalName, viewController: self)
        case .employee:
            AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
        case .enableLocation:
            AppNav.shared.pushToIntroduction(.notification, viewController: self)
        case .notification:
            AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
        case .verifyIdentity:
            // TODO : confirm this behaviour when implementing Lending 
            AppNav.shared.dismiss(self)
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
