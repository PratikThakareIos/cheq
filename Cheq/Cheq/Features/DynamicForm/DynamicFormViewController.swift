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
    
    var timer: Timer?
    var dynamicTimeInterval: Double = 15.0
    var count = 0
    
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
                //Manish
<<<<<<< HEAD
               // self.addTestAccountDetails()
=======
                self.addTestAccountDetails()
>>>>>>> Add checkSpendingStatus API
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
    
    func addTestAccountDetails(){
            guard let selectedFinancialInstitution = AppData.shared.selectedFinancialInstitution else { LoggingUtil.shared.cPrint(ValidationError.unableToMapSelectedBank); return }
    
            for view in self.stackView.subviews {
                
                if let textField = view as? CTextField {
                    let key = textField.placeholder ?? ""

                    if let loginIdCaption =  selectedFinancialInstitution.loginIdCaption, loginIdCaption == key {
                        textField.text = "gavinBelson"
                    }
                    
                    if let passwordCaption =  selectedFinancialInstitution.passwordCaption, passwordCaption == key {
                        textField.text = "hooli2016"
                    }
                }
            }
    }
    
    func registerObservables() {             
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
        guard let selectedFinancialInstitution = AppData.shared.selectedFinancialInstitution else { LoggingUtil.shared.cPrint(ValidationError.unableToMapSelectedBank); return }

        var loginId : String?
        var password : String?
        var securityCode : String?
        var secondaryLoginId : String?

        for view in self.stackView.subviews {
                        
            if let textField = view as? CTextField {
                let key = textField.placeholder ?? ""
                let value = textField.text ?? ""
                
                if let loginIdCaption =  selectedFinancialInstitution.loginIdCaption, loginIdCaption == key {
                    loginId = value
                }
                
                if let passwordCaption =  selectedFinancialInstitution.passwordCaption, passwordCaption == key {
                    password = value
                }
                
                if let securityCodeCaption =  selectedFinancialInstitution.securityCodeCaption, securityCodeCaption == key {
                    securityCode = value
                }
                
                if let secondaryLoginIdCaption =  selectedFinancialInstitution.secondaryLoginIdCaption, secondaryLoginIdCaption == key {
                    secondaryLoginId = value
                }
            }
            
//            // saving value from check box
//            if let switchWithLabel = view as? CSwitchWithLabel {
//                let key = switchWithLabel.titleLabel
//                let value = String(switchWithLabel.switchValue())
//                for prompt in form.prompts {
//                    if prompt.label == key {
//                        prompt.savedValue = value
//                    }
//                }
//            }
            
        }
        self.submitFormWith(loginId: loginId, password: password, securityCode: securityCode, secondaryLoginId: secondaryLoginId)
    }
    
    
    func submitFormWith(loginId : String?, password : String?, securityCode : String?, secondaryLoginId : String?) {
       NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
        //guard let nav =  self.navigationController else { return }
        let connectingToBank = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.connecting.rawValue, embedInNav: false)
        connectingToBank.modalPresentationStyle = .fullScreen
        self.present(connectingToBank, animated: true) { [weak self] in
            guard let self = self else { return }
             self.modalPresentationStyle = .fullScreen
             self.viewModel.coordinator.submitFormWith(loginId: loginId, password: password, securityCode: securityCode, secondaryLoginId: secondaryLoginId).done { success in
                
<<<<<<< HEAD
                self.checkSpendingStatus { result in
=======
                self.checkJobStatus { result in
>>>>>>> Add checkSpendingStatus API
                    // dismiss "connecting to bank" viewcontroller when we are ready to move to the next screen
                        switch result {
                        case .success(_):
                            
                            
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
                            
                            
//                            AppData.shared.isOnboarding = false
//                            self.viewModel.coordinator.nextViewController()
                        case .failure(let err):
                            self.dismiss(animated: true) {
                                self.showError(err, completion: nil)
                            }
                        }
                    
                }
                
            }.catch { err in
                self.dismiss(animated: true) { [weak self] in
                    //Show if wrong account credentials
                    if err.localizedDescription ==  MoneySoftManagerError.wrongUserNameOrPasswordLinkableAccounts.errorDescription {
                        
                        let transactionModal: CustomSubViewPopup = UIView.fromNib()
                        transactionModal.viewModel.data = CustomPopupModel(description:MoneySoftManagerError.invalidCredentials.localizedDescription , imageName: "needMoreInfo", modalHeight: 350, headerTitle: "Invalid bank account credentials")
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
    
    //getJobConnectionStatus
<<<<<<< HEAD
=======
    func checkJobStatus(_ completion: @escaping (Result<Bool>)->Void) {
        if AppData.shared.connectionJobStatusReady {
            completion(.success(true))
        } else {
            
            if self.count == 0 {
                self.dynamicTimeInterval = 1.0
            }
           
            if self.count == 1 || self.count == 2 {
                self.dynamicTimeInterval = 15.0
            }
            
            if self.count == 3 || self.count == 4 {
                self.dynamicTimeInterval = 10.0
            }else{
                self.dynamicTimeInterval = 5.0
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.dynamicTimeInterval) {

                 self.viewModel.coordinator.checkConnectionJobStatus().done { getConnectionJobResponse in
                   
                    LoggingUtil.shared.cPrint("\n getConnectionJobResponse = \(getConnectionJobResponse)")
                    
                    guard getConnectionJobResponse.stepStatus != GetConnectionJobResponse.StepStatus.failed  else {
                       let error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey:  getConnectionJobResponse.errorDetail]) as Error
                       completion(.failure(error))
                       return
                    }
                    
                    AppData.shared.connectionJobStatusReady = self.manageConectionJobStatus(res: getConnectionJobResponse)
                    self.checkJobStatus(completion)
                }.catch { err in
                    LoggingUtil.shared.cPrint(err)
                    completion(.failure(err))
                }
            }
        }
    }
    

>>>>>>> Add checkSpendingStatus API
    func checkSpendingStatus(_ completion: @escaping (Result<Bool>)->Void) {
        if AppData.shared.spendingOverviewReady {
            completion(.success(true))
        } else {
<<<<<<< HEAD
            
            if self.count == 0 {
                self.dynamicTimeInterval = 1.0
            }
           
            if self.count == 1 || self.count == 2 {
                self.dynamicTimeInterval = 15.0
            }
            
            if self.count == 3 || self.count == 4 {
                self.dynamicTimeInterval = 10.0
            }else{
                self.dynamicTimeInterval = 5.0
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.dynamicTimeInterval) {

                 self.viewModel.coordinator.checkConnectionJobStatus().done { getConnectionJobResponse in
                    
                    guard getConnectionJobResponse.stepStatus != GetConnectionJobResponse.StepStatus.failed  else {
                       LoggingUtil.shared.cPrint("\n manageConectionJobStatus GetConnectionJobResponse.StepStatus.failed")
                       LoggingUtil.shared.cPrint("\n res.errorTitle = \(getConnectionJobResponse.errorTitle)")
                       LoggingUtil.shared.cPrint("\n res.errorDetail = \(getConnectionJobResponse.errorDetail)")
                  
                       let error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey:  getConnectionJobResponse.errorDetail]) as Error
                       completion(.failure(error))
                       return
                    }
                    
                    AppData.shared.spendingOverviewReady = self.manageConectionJobStatus(res: getConnectionJobResponse)
=======
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                CheqAPIManager.shared.spendingStatus().done { getSpendingStatusResponse in
                    LoggingUtil.shared.cPrint("\n getSpendingStatusResponse = \(getSpendingStatusResponse)")
                    AppData.shared.spendingOverviewReady = (getSpendingStatusResponse.transactionStatus == GetSpendingStatusResponse.TransactionStatus.ready) ? true : false
>>>>>>> Add checkSpendingStatus API
                    self.checkSpendingStatus(completion)
                }.catch { err in
                    LoggingUtil.shared.cPrint(err)
                    completion(.failure(err))
                }
            }
        }
    }
    
<<<<<<< HEAD

=======
>>>>>>> Add checkSpendingStatus API
    

//
//    @objc func confirm(_ sender: Any) {
//        LoggingUtil.shared.cPrint("confirm")
//        guard AppData.shared.financialSignInForm.financialServiceId != AppData.shared.financialInstitutionsUnused else { LoggingUtil.shared.cPrint("financialSignInForm not loaded"); return }
//        let form = AppData.shared.financialSignInForm
//        for view in self.stackView.subviews {
//            if let textField = view as? CTextField {
//                let key = textField.placeholder ?? ""
//                let value = textField.text ?? ""
//                for prompt in form.prompts {
//                    if prompt.label == key {
//                        prompt.savedValue = value
//                    }
//                }
//            }
//
//            // saving value from check box
//            if let switchWithLabel = view as? CSwitchWithLabel {
//                let key = switchWithLabel.titleLabel
//                let value = String(switchWithLabel.switchValue())
//                for prompt in form.prompts {
//                    if prompt.label == key {
//                        prompt.savedValue = value
//                    }
//                }
//            }
//        }
//
//        // update the form with input entries
//        AppData.shared.financialSignInForm = form
//        self.submitForm()
//    }

    
    
//    func submitForm() {
//       NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
//        //guard let nav =  self.navigationController else { return }
//        let connectingToBank = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.connecting.rawValue, embedInNav: false)
//        connectingToBank.modalPresentationStyle = .fullScreen
//
//        self.present(connectingToBank, animated: true) { [weak self] in
//            guard let self = self else { return }
//             self.modalPresentationStyle = .fullScreen
//            self.viewModel.coordinator.submitForm().done { success in
//                self.checkSpendingStatus { result in
//                    // dismiss "connecting to bank" viewcontroller when we are ready to move to the next screen
//                    self.dismiss(animated: true) {
//                        switch result {
//                        case .success(_):
//                            AppData.shared.isOnboarding = false
//                            self.viewModel.coordinator.nextViewController()
//                        case .failure(let err):
//                            self.showError(err, completion: nil)
//                        }
//                    }
//                }
//            }.catch { err in
//                self.dismiss(animated: true) { [weak self] in
//                                     //Show if wrong account credentials
//                    if err.localizedDescription ==  MoneySoftManagerError.wrongUserNameOrPasswordLinkableAccounts.errorDescription {
//
//                        let transactionModal: CustomSubViewPopup = UIView.fromNib()
//                        transactionModal.viewModel.data = CustomPopupModel(description:MoneySoftManagerError.invalidCredentials.localizedDescription , imageName: "needMoreInfo", modalHeight: 350, headerTitle: "Invalid bank account credentials")
//                                         transactionModal.setupUI()
//                                         let popupView = CPopupView(transactionModal)
//
//                                         popupView.show()
//
//                    }else{
//                       let connectingFailed =  AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.reTryConnecting.rawValue, embedInNav: false)
//                        self?.present(connectingFailed, animated: true)
//                     // self?.showError(err, completion: nil)
//                    }
//                }
//            }
//        }
//    }
    
<<<<<<< HEAD
//    func checkSpendingStatus(_ completion: @escaping (Result<Bool>)->Void) {
//        if AppData.shared.spendingOverviewReady {
//            completion(.success(true))
//        } else {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                CheqAPIManager.shared.spendingStatus().done { getSpendingStatusResponse in
//                    AppData.shared.spendingOverviewReady = (getSpendingStatusResponse.transactionStatus == GetSpendingStatusResponse.TransactionStatus.ready) ? true : false
//                    self.checkSpendingStatus(completion)
//                }.catch { err in
//                    LoggingUtil.shared.cPrint(err)
//                    completion(.failure(err))
//                }
//            }
//        }
//    }
=======

>>>>>>> Add checkSpendingStatus API
    
 }
 
 extension DynamicFormViewController {
    
     @objc func reSubmitForm(_ notification: NSNotification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
              //self.submitForm()
        })
    
    }
 }
<<<<<<< HEAD

 
 // MARK: - Timer
 extension DynamicFormViewController {
    
    func manageConectionJobStatus(res: GetConnectionJobResponse) -> Bool {
             LoggingUtil.shared.cPrint("\n manageConectionJobStatus Called")
            /*
            ConnectionStep

            VerifyingCredentials: logging into user’s internet bank
            RetrievingAccounts: getting financial account info
            RetrievingTransactions: getting financial transactions info
            Categorisation: processing financial transactions

            ConnectionStepStatus

=======

 
 // MARK: - Timer
 extension DynamicFormViewController {
    
    func manageConectionJobStatus(res: GetConnectionJobResponse) -> Bool {
             LoggingUtil.shared.cPrint("\n manageConectionJobStatus Called")
            /*
            ConnectionStep

            VerifyingCredentials: logging into user’s internet bank
            RetrievingAccounts: getting financial account info
            RetrievingTransactions: getting financial transactions info
            Categorisation: processing financial transactions

            ConnectionStepStatus

>>>>>>> Add checkSpendingStatus API
            Pending
            InProgress
            Failed: failed, ask users to try again, show the error message based on

            ErrorTitle
            ErrorDetail

            Success: can look at the Categorisation status now.

            CategorizingTransactionStatus = Ready, you can navigating to spending dashboard page.
     
            */
            
    //        public enum Step: String, Codable {
    //            case verifyingCredentials = "VerifyingCredentials"
    //            case retrievingAccounts = "RetrievingAccounts"
    //            case retrievingTransactions = "RetrievingTransactions"
    //            case categorisation = "Categorisation"
    //        }
    //        public enum StepStatus: String, Codable {
    //            case pending = "Pending"
    //            case inProgress = "InProgress"
    //            case failed = "Failed"
    //            case success = "Success"
    //        }
    //        public enum ModelError: String, Codable {
    //            case invalidCredentials = "InvalidCredentials"
    //            case actionRequiredByBank = "ActionRequiredByBank"
    //            case maintenanceError = "MaintenanceError"
    //            case temporaryUnavailable = "TemporaryUnavailable"
    //        }
    //        public var institutionId: String?
    //        public var step: Step?
    //        public var stepStatus: StepStatus?
    //        public var error: ModelError?
    //        public var errorTitle: String?
    //        public var errorDetail: String?
            
            
//            guard res.stepStatus != GetConnectionJobResponse.StepStatus.failed  else {
//                LoggingUtil.shared.cPrint("\n manageConectionJobStatus GetConnectionJobResponse.StepStatus.failed")
//                LoggingUtil.shared.cPrint("\n res.errorTitle = \(res.errorTitle)")
//                LoggingUtil.shared.cPrint("\n res.errorDetail = \(res.errorDetail)")
//                return false
//            }
            
            NotificationUtil.shared.notify(UINotificationEvent.basiqEvent.rawValue, key: NotificationUserInfoKey.basiqProgress.rawValue, object: res.step)

            
            switch res.step {
            case .verifyingCredentials:
                    LoggingUtil.shared.cPrint("Connecting to <bank name> ...") //25%
                    return false
            case .retrievingAccounts:
                    LoggingUtil.shared.cPrint("Retrieving statements from bank...") //50%
                    return false
            case .retrievingTransactions:
                    LoggingUtil.shared.cPrint("Analysing your bank statement...") //70
                    return false
            case .categorisation:
                    LoggingUtil.shared.cPrint("Categorising your transactions...") //80
                    if (res.stepStatus == GetConnectionJobResponse.StepStatus.success){
                        return true
                    }else{
                        return false
                    }
          
            default:
                   LoggingUtil.shared.cPrint("manageConectionJobStatus - Something went wrong")
                   return false
            }
                    
        }
    
   func activateTimer(){
      timer = Timer.scheduledTimer(timeInterval: dynamicTimeInterval, target: self, selector: #selector(timerMethod), userInfo: nil, repeats: true)
   }

   @objc func timerMethod() {
       print("Timer method called = \(dynamicTimeInterval) and count = \(count)")
       count = count + 1
       if count == 3 {
           self.changeAPICallTime(timeInSecond: 10)
       }
       
       if count == 5 {
           self.changeAPICallTime(timeInSecond: 5)
       }
   }
   
   func changeAPICallTime(timeInSecond : Double){
       endTimer()
       dynamicTimeInterval = timeInSecond
       activateTimer()
   }
    func endTimer(){
        if let _ = self.timer {
                   self.timer?.invalidate()
        }
    }
    
 }
