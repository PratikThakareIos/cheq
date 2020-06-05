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

    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var questionTitle: CLabel! 
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewBank: UIView!
    @IBOutlet weak var imgVWBankLogo: UIImageView!
    @IBOutlet weak var lblBankName: UILabel!
    
    var built = false
    
    var resGetUserActionResponse : GetUserActionResponse?
    var viewModel = DynamicFormViewModel()
    var form:[DynamicFormInput] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        
        self.sectionTitle.textColor = AppConfig.shared.activeTheme.lightGrayColor
        self.sectionTitle.font = AppConfig.shared.activeTheme.defaultMediumFont
        
        self.questionTitle.font = AppConfig.shared.activeTheme.headerBoldFont
        self.questionTitle.textColor = AppConfig.shared.activeTheme.textColor
               
        self.questionTitle.text = self.viewModel.coordinator.viewTitle
        self.sectionTitle.text = self.viewModel.coordinator.sectionTitle
       
        if AppData.shared.isOnboarding {
            AppConfig.shared.progressNavBar(progress: AppData.shared.progress, viewController: self)
        }
        
        if let res = resGetUserActionResponse {
            self.manageCanSelectBankCase(canSelectBank : res.canSelectBank ?? false)
        }
        
        self.addBankTitleAndLogo()
    }
    
    func addBankTitleAndLogo(){
        guard let institution = AppData.shared.selectedFinancialInstitution else { return }
        self.viewBank.isHidden = false
        self.lblBankName.text = institution.shortName ?? "N/A"
        self.imgVWBankLogo.image = UIImage.init(named: BankLogo.placeholder.rawValue)
         if var view: UIView = self.imgVWBankLogo {
              ViewUtil.shared.circularMask(&view, radiusBy: .height)
         }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                self.imgVWBankLogo.layer.cornerRadius =  self.imgVWBankLogo.frame.height/2
        })
        

         if let imageName = institution._id, imageName.isEmpty == false {
            if let url = URL(string: imageName), UIApplication.shared.canOpenURL(url as URL) {
                self.imgVWBankLogo.setImageForURL(imageName)
            }else{
                if let img = UIImage.init(named: imageName){
                    self.imgVWBankLogo.image = img
                }
            }
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
                //self.addTestAccountDetails()
                self.showAlertPopUpIfNeeded()
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
                textField.backgroundColor = UIColor.white
                textField.setShadow()
                return textField
            
            case .password:
                let passwordTextField = CTextField(frame: CGRect.zero)
                passwordTextField.placeholder = input.title
                passwordTextField.isSecureTextEntry = true
                passwordTextField.backgroundColor = UIColor.white
                passwordTextField.setShadow()
                return passwordTextField
            
            case .checkBox:
                let switchView = CSwitchWithLabel(frame: CGRect.zero, title: input.title)
                return switchView
            
            case .confirmButton:
                let confirmButton = CButton(frame: CGRect.zero)
                confirmButton.type = .normal
                confirmButton.createShadowLayer()
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
        
        if (loginId == "" || password == "") {
            showError(ValidationError.invalidInputFormat) { }
            return
        }

        self.submitFormWith(loginId: loginId, password: password, securityCode: securityCode, secondaryLoginId: secondaryLoginId)
    }

    func submitFormWith(loginId : String?, password : String?, securityCode : String?, secondaryLoginId : String?) {
      
//        var isUpdate =  false
//        if let res = self.resGetUserActionResponse, res.userAction == .invalidCredentials {
//               isUpdate = true
//        }
        
        
        NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
        //guard let nav =  self.navigationController else { return }
        AppConfig.shared.showSpinner()
        self.viewModel.coordinator.submitFormWith(loginId: loginId, password: password, securityCode: securityCode, secondaryLoginId: secondaryLoginId).done { success in
            AppConfig.shared.hideSpinner {
                 self.gotoConnectingToBankViewController()
            }
        }.catch { err in
            //self.dismiss(animated: true) { [weak self] in
                
            AppConfig.shared.hideSpinner {
                //Show if wrong account credentials
                if err.localizedDescription ==  MoneySoftManagerError.wrongUserNameOrPasswordLinkableAccounts.errorDescription {
                    let transactionModal: CustomSubViewPopup = UIView.fromNib()
                    transactionModal.viewModel.data = CustomPopupModel(description:MoneySoftManagerError.invalidCredentials.localizedDescription , imageName: "needMoreInfo", modalHeight: 350, headerTitle: "Invalid bank account credentials")
                                     transactionModal.setupUI()
                    let popupView = CPopupView(transactionModal)
                    popupView.show()

                }else{
                    let connectingFailed =  AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.reTryConnecting.rawValue, embedInNav: false)
                    connectingFailed.modalPresentationStyle = .fullScreen
                    self.present(connectingFailed, animated: true)
                }
            }
        }
    }
    
    func gotoConnectingToBankViewController(){
        
        if let connectingToBank = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.connecting.rawValue, embedInNav: false) as? ConnectingToBankViewController {
            connectingToBank.modalPresentationStyle = .fullScreen
            connectingToBank.delegate = self
            connectingToBank.jobId = AppData.shared.bankJobId
            self.present(connectingToBank, animated: true, completion: nil)
        }
    }
    
    
//    func submitFormWith(loginId : String?, password : String?, securityCode : String?, secondaryLoginId : String?) {
//
//        NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
//        //guard let nav =  self.navigationController else { return }
//        let connectingToBank = AppNav.shared.initViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.connecting.rawValue, embedInNav: false)
//        connectingToBank.modalPresentationStyle = .fullScreen
//        self.present(connectingToBank, animated: true) { [weak self] in
//            guard let self = self else { return }
//             self.modalPresentationStyle = .fullScreen
//             self.viewModel.coordinator.submitFormWith(loginId: loginId, password: password, securityCode: securityCode, secondaryLoginId: secondaryLoginId).done { success in
//
//                self.checkJobStatus { result in
//                    // dismiss "connecting to bank" viewcontroller when we are ready to move to the next screen
//                        switch result {
//                        case .success(_):
//                            LoggingUtil.shared.cPrint("total checkJobStatus count = \(self.count)")
//
//                            self.dismiss(animated: true) {
//                                AppData.shared.isOnboarding = false
//                                self.viewModel.coordinator.nextViewController()
//                            }
//
//                        case .failure(let err):
//
//                            self.dismiss(animated: true) {
//                                self.showError(err, completion: nil)
//                            }
//                        }
//                }
//            }.catch { err in
//                self.dismiss(animated: true) { [weak self] in
//                    //Show if wrong account credentials
//                    if err.localizedDescription ==  MoneySoftManagerError.wrongUserNameOrPasswordLinkableAccounts.errorDescription {
//
//                        let transactionModal: CustomSubViewPopup = UIView.fromNib()
//                        transactionModal.viewModel.data = CustomPopupModel(description:MoneySoftManagerError.invalidCredentials.localizedDescription , imageName: "needMoreInfo", modalHeight: 350, headerTitle: "Invalid bank account credentials")
//                                         transactionModal.setupUI()
//                        let popupView = CPopupView(transactionModal)
//                        popupView.show()
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
    
//    //getJobConnectionStatus
//    func checkJobStatus(_ completion: @escaping (Result<Bool>)->Void) {
//
//        if AppData.shared.connectionJobStatusReady {
//            completion(.success(true))
//        } else {
//
//            if self.count == 0 {
//                self.dynamicTimeInterval = 1.0
//            }
//
//            if self.count == 1 || self.count == 2 {
//                self.dynamicTimeInterval = 15.0
//            }
//
//            if self.count == 3 || self.count == 4 {
//                self.dynamicTimeInterval = 10.0
//            }else{
//                self.dynamicTimeInterval = 5.0
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + self.dynamicTimeInterval) {
//
//                 self.viewModel.coordinator.checkConnectionJobStatus().done { getConnectionJobResponse in
//
//                    LoggingUtil.shared.cPrint("\n getConnectionJobResponse = \(getConnectionJobResponse)")
//
//                    guard getConnectionJobResponse.stepStatus != GetConnectionJobResponse.StepStatus.failed  else {
//                       let error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey:  getConnectionJobResponse.errorDetail]) as Error
//                       completion(.failure(error))
//                       return
//                    }
//                    AppData.shared.connectionJobStatusReady = self.manageConectionJobStatus(res: getConnectionJobResponse)
//                    self.checkJobStatus(completion)
//                }.catch { err in
//                    LoggingUtil.shared.cPrint(err)
//                    completion(.failure(err))
//                }
//            }
//        }
//    }
//

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

 }
 
 extension DynamicFormViewController {
    
     @objc func reSubmitForm(_ notification: NSNotification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
              //self.submitForm()
        })
    }
 }
 
 
 //MARK: - Verification popup
 extension DynamicFormViewController {
    func showAlertPopUpIfNeeded(){
        guard let res = self.resGetUserActionResponse else { return }
        LoggingUtil.shared.cPrint(res)
        switch (res.userAction){
            
            case .genericInfo:
                 LoggingUtil.shared.cPrint("go to home screen")
                 break
                            
            case .bankLinkingUnsuccessful:
                 break
            
            case .categorisationInProgress:
                break
                
            case ._none:
                break
                
            case .actionRequiredByBank:
                break
                
            case .bankNotSupported:
                break
                        
            case .invalidCredentials:
                self.showCommonPopUp()
                break
                
            case .missingAccount:
                break
                
            case .requireMigration:
              self.showCommonPopUp()
              break
            
            case .requireBankLinking:
                break
            
            case .accountReactivation:
                self.showCommonPopUp()
                break
         
            case .none:
               break
        }

    }
 }

 
 //MARK: - Verification popup
 extension DynamicFormViewController: VerificationPopupVCDelegate{
  
     func showCommonPopUp(){
        
//        ["\n>> userActionResponse = GetUserActionResponse(userAction: Optional(Cheq.GetUserActionResponse.UserAction.invalidCredentials), title: Optional(\"Reconnect to your bank\"), detail: Optional(\"We noticed that your bank credentials may have changed since you last logged in. Please enter your login details\"), linkedInstitutionId: Optional(\"AU00001\"), canSelectBank: Optional(true), showClose: Optional(true), showReconnect: Optional(false), showChatWithUs: Optional(false), actionRequiredGuidelines: nil, link: nil)"]
        
//        ["\n>> userActionResponse = GetUserActionResponse(userAction: Optional(Cheq_DEV.GetUserActionResponse.UserAction.accountReactivation), title: Optional(\"Connect your bank\"), detail: Optional(\"Welcome back, it\\\'s been a while since you\\\'ve logged in. Simply reconnect your bank to get started.\"), linkedInstitutionId: Optional(\"AU00001\"), canSelectBank: Optional(false), showClose: Optional(true), showReconnect: Optional(false), showChatWithUs: Optional(false), actionRequiredGuidelines: nil, link: nil)"]
        
        guard let res = self.resGetUserActionResponse else { return }
        self.manageCanSelectBankCase(canSelectBank : res.canSelectBank ?? false)
        self.openPopupWith(heading: res.title ?? "",
                            message: res.detail ?? "",
                            buttonTitle: "",
                            showSendButton: false,
                            emoji: UIImage(named: "bank"),
                            isShowSecurityImage: true)
     }
     
     func openPopupWith(heading:String?,message:String?,buttonTitle:String?,showSendButton:Bool?,emoji:UIImage?, isShowSecurityImage:Bool = false  ){
         self.view.endEditing(true)
         let storyboard = UIStoryboard(name: StoryboardName.Popup.rawValue, bundle: Bundle.main)
         if let popupVC = storyboard.instantiateInitialViewController() as? VerificationPopupVC{
             popupVC.delegate = self
             popupVC.heading = heading ?? ""
             popupVC.message = message ?? ""
             popupVC.buttonTitle = buttonTitle ?? ""
             popupVC.showSendButton = showSendButton ?? false
             popupVC.emojiImage = emoji ?? UIImage()
             popupVC.isShowViewSecurityImage = isShowSecurityImage
             self.present(popupVC, animated: false, completion: nil)
         }
     }
     
     func tappedOnSendButton(){
  
     }
     
     func tappedOnCloseButton(){
       
     }
 }
 
 extension DynamicFormViewController : ConnectingToBankViewControllerProtocol {
    
//    GetConnectionJobResponse(institutionId: Optional(\"AU00001\"), step: Optional(Cheq.GetConnectionJobResponse.Step.verifyingCredentials), stepStatus: Optional(Cheq.GetConnectionJobResponse.StepStatus.failed), error: nil, errorTitle: Optional(\"Invalid bank account credentials\"), errorDetail: Optional(\"Warning, attempting this multiple times with the wrong credentials might lock you out of your internet banking\"), showClose: Optional(true), showReconnect: Optional(false), showChatWithUs: Optional(false), canSelectBank: Optional(true), actionRequiredGuidelines: nil)

 
    func dismissViewController(connectionJobResponse : GetConnectionJobResponse?){
        self.view.endEditing(true)
        self.showPopUpverifyingCredentialsFailed(connectionJobResponse: connectionJobResponse)
    }
    
    func showPopUpverifyingCredentialsFailed(connectionJobResponse : GetConnectionJobResponse?){
       
        guard let res = connectionJobResponse, (res.step == .verifyingCredentials && res.stepStatus == .failed) else { return }
        self.manageCanSelectBankCase(canSelectBank : res.canSelectBank ?? false)
        
        self.openPopupWith(heading: res.errorTitle ?? "",
                            message: res.errorDetail ?? "",
                            buttonTitle: "",
                            showSendButton: false,
                            emoji: UIImage(named: "image-moreInfo"),
                            isShowSecurityImage: false)
    }

    func manageCanSelectBankCase(canSelectBank : Bool){
        if canSelectBank {
            showNavBar()
            showBackButton()
            AppConfig.shared.progressNavBar(progress: AppData.shared.progress, viewController: self)
        }else{
            self.hideNavBar()
            self.hideBackButton()
        }
    }
 }

 
 
