//
//  LendingViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import PullToRefreshKit

class LendingViewController: CTableViewController {
    
    var lendingOverviewResponse : GetLendingOverviewResponse?

    override func registerCells() {
        let cellModels: [TableViewCellViewModelProtocol] = [DeclineDetailViewModel(), SpacerTableViewCellViewModel(), SwipeToConfirmTableViewCellViewModel(), AgreementItemTableViewCellViewModel(), AmountSelectTableViewCellViewModel(), HistoryItemTableViewCellViewModel(), CButtonTableViewCellViewModel(), HeaderTableViewCellViewModel(), CompleteDetailsTableViewCellViewModel(), CompletionProgressTableViewCellViewModel(), IntercomChatTableViewCellViewModel(), BottomTableViewCellViewModel(), TransferCardTableViewCellViewModel(), MessageBubbleTableViewCellViewModel(), TopTableViewCellViewModel()]
        for vm: TableViewCellViewModelProtocol in cellModels {
            let nib = UINib(nibName: vm.identifier, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LendingViewModel()
        hideNavBar()
        setupUI()
        setupDelegate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        registerObservables()
        NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
        getTransactionData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }

    func setupUI() {
        hideBackTitle()
        self.tableView.addPullToRefreshAction {
            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
            self.getTransactionData()
        }
    }
    
    func registerObservables() {
        
        setupKeyboardHandling()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.reloadTable.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.completeDetails(_:)), name: NSNotification.Name(UINotificationEvent.completeDetails.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.lendingOverview(_:)), name: NSNotification.Name(UINotificationEvent.lendingOverview.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.intercom(_:)), name: NSNotification.Name(UINotificationEvent.intercom.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.button(_:)), name: NSNotification.Name(UINotificationEvent.buttonClicked.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showErr(_:)), name: NSNotification.Name(UINotificationEvent.showError.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.turnOnLocation(_:)), name: NSNotification.Name(UINotificationEvent.turnOnLocation.rawValue), object: nil)
                
        //selectYourSalary
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectYourSalary(_:)), name: NSNotification.Name(UINotificationEvent.selectYourSalary.rawValue), object: nil)
        
        //creditAssessment
        NotificationCenter.default.addObserver(self, selector: #selector(self.creditAssessment(_:)), name: NSNotification.Name(UINotificationEvent.creditAssessment.rawValue), object: nil)
        
        //learnMore
        NotificationCenter.default.addObserver(self, selector: #selector(self.learnMore(_:)), name: NSNotification.Name(UINotificationEvent.learnMore.rawValue), object: nil)
       
    }
}

// observable handlers
extension LendingViewController {
    /// handle selectYourSalary notification event
    @objc func selectYourSalary(_ notification: NSNotification) {
       LoggingUtil.shared.cPrint("selectYourSalary clicked")
       LoggingUtil.shared.cPrint("\nAppData.shared.employeePaycycle = \(AppData.shared.employeePaycycle)")
        
          AppConfig.shared.showSpinner()
          CheqAPIManager.shared.getSalaryPayCycleTimeSheets()
              .done { paycyles in
                  print("paycyles = \(paycyles)")
                  AppConfig.shared.hideSpinner {
                      print("Transaction success")
                      if AppData.shared.employeePaycycle.count == 0 {
                        //show popup
                        self.showNoIncomeDetectedPopUp()
                      }else{
                        //Todo : show salary transaction selection screen
                        AppData.shared.completingDetailsForLending = true
                        self.showTransactionSelectionScreen()
                      }
                  }
          }.catch { err in
              AppConfig.shared.hideSpinner {
                  self.showError(err) {
                      print("error")
                  }
              }
          }
    }
    
    
    /// handle creditAssessment notification event
    @objc func creditAssessment(_ notification: NSNotification) {
       LoggingUtil.shared.cPrint("creditAssessment clicked")
        
        guard let link = notification.userInfo?[NotificationUserInfoKey.link.rawValue] as? String else { return }
        guard let url = URL(string: link) else { return }
        AppNav.shared.pushToInAppWeb(url, viewController: self)
    }
    
    
    /// handle learnMore notification event
    @objc func learnMore(_ notification: NSNotification) {
        LoggingUtil.shared.cPrint("learnMore clicked")
        
        guard let link = notification.userInfo?[NotificationUserInfoKey.link.rawValue] as? String else { return }
        guard let url = URL(string: link) else { return }
        AppNav.shared.pushToInAppWeb(url, viewController: self)
    }

    
    @objc func completeDetails(_ notificaton: NSNotification) {
        //["type"] as? String  is just the key set on CompleteDetailsTableViewCell for the user object
        guard let completeDetailsType = notificaton.userInfo?["type"] as? String else { return }
        let type: CompleteDetailsType = CompleteDetailsType(fromRawValue: completeDetailsType)
        switch type {
        case .workDetails:
            AppData.shared.completingDetailsForLending = true
            AppNav.shared.presentToMultipleChoice(.employmentType, viewController: self)
        case .bankDetils:
            AppData.shared.completingDetailsForLending = true
            // banking details flow
            AppNav.shared.presentToQuestionForm(.bankAccount, viewController: self)
        case .verifyYourDetails:
            // verification flow
            AppData.shared.completingDetailsForLending = true
            AppNav.shared.presentToQuestionForm(.legalName, viewController: self)
        case .workVerify:
            AppData.shared.completingDetailsForLending = true
            print("verify work details")
            //Needs to pass the screen
        }
    }
    
    func showDeclineIfNeeded(_ lendingOverview: GetLendingOverviewResponse) {
        let viewModel = self.viewModel as! LendingViewModel
        guard viewModel.declineExist(lendingOverview) == false else {
            if let declineDetails = lendingOverview.decline, let declineReason = declineDetails.declineReason {
                AppData.shared.declineDescription = declineDetails.declineDescription ?? ""
                AppNav.shared.presentDeclineViewController(declineReason, viewController: self)
            } else {
                self.showError(CheqAPIManagerError.errorHasOccurredOnServer, completion: nil)
            }
            return
        }
    }
    
    @objc func showErr(_ notification: NSNotification) {
        if let err = notification.userInfo?[NotificationUserInfoKey.err.rawValue] as? Error {
            showError(err, completion: nil)
        }
    }
    
    @objc func turnOnLocation(_ notification: NSNotification) {
        if let action = notification.userInfo?[NotificationUserInfoKey.turnOnLocation.rawValue] as? String{
            if action == UserAction.Action.turnOnLocation.rawValue {
                CompleteDetailsTableViewCellViewModel.turnOnlocation = true
                AppNav.shared.pushToIntroduction(.enableLocation, viewController: self)
            }else {
                CompleteDetailsTableViewCellViewModel.turnOnlocation = false
                showMessage("No time sheets yet", completion: nil)
            }
       }        
    }
    
    func renderLending(_ lendingOverview: GetLendingOverviewResponse) {
        LoggingUtil.shared.cPrint(lendingOverview)
        self.lendingOverviewResponse = lendingOverview
        
        guard let viewModel = self.viewModel as? LendingViewModel else { return }
        let isDeclineExist  = viewModel.declineExist(lendingOverview)
        if isDeclineExist {
            if let declineDetails = lendingOverview.decline, let declineReason = declineDetails.declineReason {
                AppData.shared.declineDescription = declineDetails.declineDescription ?? ""
                //AppNav.shared.presentDeclineViewController(declineReason, viewController: self)
                viewModel.render(lendingOverview)
            } else {
                self.showError(CheqAPIManagerError.errorHasOccurredOnServer, completion: nil)
            }
        }else{
            LoggingUtil.shared.cPrint("build view model here...")
            viewModel.render(lendingOverview)
        }

//        let isDeclineExist  = self.declineExist(lendingOverview)
//        if isDeclineExist {
//            self.showDeclineIfNeeded(lendingOverview)
//        }else{
//            LoggingUtil.shared.cPrint("build view model here...")
//            guard let vm = self.viewModel as? LendingViewModel else { return }
//            vm.render(lendingOverview)
//        }
        
    }
    
    @objc func lendingOverview(_ notification: NSNotification) {
        
        AppConfig.shared.showSpinner()
        
        AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
             AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
        }.then { authUser in
            CheqAPIManager.shared.lendingOverview()
        }.done{ overview in
                AppConfig.shared.hideSpinner {
                    //print("\n\nLending view controller = \(overview)")
                    self.renderLending(overview)
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err) {
                        NotificationUtil.shared.notify(NotificationEvent.logout.rawValue, key: "", object: "")
                    }
                }
            }
    }
  
    private func getTransactionData() {
        
        print("\nAppData.shared.employeePaycycle = \(AppData.shared.employeePaycycle)")
        if AppData.shared.employeePaycycle.count == 0 {
            //AppConfig.shared.showSpinner()
            CheqAPIManager.shared.getSalaryPayCycleTimeSheets()
                .done { paycyles in
                    print("paycyles = \(paycyles)")
                   // AppConfig.shared.hideSpinner {
                        print("Transaction success")
                   // }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err) {
                        print("error")
                    }
                }
            }
        }
    }
    
    func kycHasCompleted(_ status: EligibleRequirement.KycStatus)-> Bool {
        switch status {
            case .createdApplicant, .inProcessing, .notStarted, .blocked: return false
            default: return true
        }
    }
  
    @objc func button(_ notification: NSNotification) {
        
        guard let buttonCell = notification.userInfo?[NotificationUserInfoKey.button.rawValue] as? CButtonTableViewCell else { return }
    
        if buttonCell.button.titleLabel?.text == keyButtonTitle.Cashout.rawValue {
            // go to preview loan
            if let lendingOverview =  self.lendingOverviewResponse, let borrowOverview = lendingOverview.borrowOverview  {
                  let availableCashoutAmount = borrowOverview.availableCashoutAmount ?? 0

                if (availableCashoutAmount > 0){
                    let borrowAmount = Double(AppData.shared.amountSelected) ?? 0.0
                    if borrowAmount > 0.0 {
                        AppNav.shared.presentPreviewLoanViewController(viewController: self)
                        //AppNav.shared.pushToViewController(StoryboardName.main.rawValue, storyboardId: MainStoryboardId.preview.rawValue, viewController: self)
                    }else{
                        showMessage("Please select loan amount", completion: nil)
                    }
                }else{
                    self.popup_NotEnoughCashToWithdraw()
                }
            }
        }
    }
    
    func showTransactionSelectionScreen() {
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: SalaryPaymentViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.salaryPayments.rawValue) as! SalaryPaymentViewController
        vc.isFromLendingScreen = true
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
     }
    
    
//    func declineExist(_ lendingOverview: GetLendingOverviewResponse)-> Bool {
//        guard let eligibleRequirements = lendingOverview.eligibleRequirement else { return false }
//        let viewModel = self.viewModel as! LendingViewModel
//
//        let kycSuceeded = viewModel.isKycStatusFailed(eligibleRequirements.kycStatus ?? .notStarted)
//        let kycFailed = viewModel.isKycStatusSuccess(eligibleRequirements.kycStatus ?? .notStarted)
//
//        // if kyc is not completed, if means it's pending for action or waiting as it's in processing
//        let kycCompleted = kycSuceeded || kycFailed
//
//        if (eligibleRequirements.hasBankAccountDetail ?? false && eligibleRequirements.hasEmploymentDetail ?? false && kycCompleted) {
//            return false
//        }
//        //guard eligibleRequirements.hasBankAccountDetail == true, eligibleRequirements.hasEmploymentDetail == true, kycCompleted == true else { return false }
//
//        guard let declineDetails = lendingOverview.decline, let reason = declineDetails.declineReason else { return false }
//
//        guard reason != ._none else { return false }
//
//        return true
//    }
    
    
}


//MARK: - Verification popup
extension LendingViewController: VerificationPopupVCDelegate{
    
    func showNoIncomeDetectedPopUp(){
        self.openPopupWith(heading: "No income detected for selection",
                           message: "Our bot can't detect an incoming transaction for you to select. Please make sure you're getting paid in the bank account that you connected",
                           buttonTitle: "",
                           showSendButton: false,
                           emoji: UIImage(named: "sucsess"))
     }
 
    func popup_NotEnoughCashToWithdraw(){
        self.openPopupWith(heading: "Not enough cash to withdraw",
                           message: "You don’t have an available balance to be able to cash out at the moment",
                           buttonTitle: "",
                           showSendButton: false,
                           emoji: UIImage(named: "transferFailed"))
     }
    
    
    func openPopupWith(heading:String?,message:String?,buttonTitle:String?,showSendButton:Bool?,emoji:UIImage?){
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: StoryboardName.Popup.rawValue, bundle: Bundle.main)
        if let popupVC = storyboard.instantiateInitialViewController() as? VerificationPopupVC{
            popupVC.delegate = self
            popupVC.heading = heading ?? ""
            popupVC.message = message ?? ""
            popupVC.buttonTitle = buttonTitle ?? ""
            popupVC.showSendButton = showSendButton ?? false
            popupVC.emojiImage = emoji ?? UIImage()
            self.tabBarController?.present(popupVC, animated: false, completion: nil)
        }
    }
    
    func tappedOnSendButton(){
 
    }
    
    func tappedOnCloseButton(){
      
    }
}


