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

    override func registerCells() {
        let cellModels: [TableViewCellViewModelProtocol] = [SpacerTableViewCellViewModel(), SwipeToConfirmTableViewCellViewModel(), AgreementItemTableViewCellViewModel(), AmountSelectTableViewCellViewModel(), HistoryItemTableViewCellViewModel(), CButtonTableViewCellViewModel(), HeaderTableViewCellViewModel(), CompleteDetailsTableViewCellViewModel(), CompletionProgressTableViewCellViewModel(), IntercomChatTableViewCellViewModel(), BottomTableViewCellViewModel(), TransferCardTableViewCellViewModel(), MessageBubbleTableViewCellViewModel(), TopTableViewCellViewModel()]
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }

    func setupUI() {
        hideBackTitle()
        self.tableView.addPullToRefreshAction {            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
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
    }
}

// observable handlers
extension LendingViewController {
    
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
            AppData.shared.completingDetailsForLending = true
            // verification flow
            AppNav.shared.presentToQuestionForm(.legalName, viewController: self)
        case .workVerify:
            AppData.shared.completingDetailsForLending = true
            print("verify work details")
            //Needs to pass the screen
        }
    }
    
    func showDeclineIfNeeded(_ lendingOverview: GetLendingOverviewResponse) {
        guard self.declineExist(lendingOverview) == false else {
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
        self.showDeclineIfNeeded(lendingOverview)
        LoggingUtil.shared.cPrint("build view model here...")
        guard let vm = self.viewModel as? LendingViewModel else { return }
        vm.render(lendingOverview)
    }
    
    @objc func lendingOverview(_ notification: NSNotification) {
        AppConfig.shared.showSpinner()
            CheqAPIManager.shared.lendingOverview()
            .done{ overview in
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
    
    func declineExist(_ lendingOverview: GetLendingOverviewResponse)-> Bool {
        guard let eligibleRequirements = lendingOverview.eligibleRequirement else { return false }
        let viewModel = self.viewModel as! LendingViewModel
        
        let kycSuceeded = viewModel.isKycStatusFailed(eligibleRequirements.kycStatus ?? .notStarted)
        let kycFailed = viewModel.isKycStatusSuccess(eligibleRequirements.kycStatus ?? .notStarted)
        
        // if kyc is not completed, if means it's pending for action or waiting as it's in processing
        let kycCompleted = kycSuceeded || kycFailed
        
        guard eligibleRequirements.hasBankAccountDetail == true, eligibleRequirements.hasEmploymentDetail == true, kycCompleted == true else { return false }
        
        guard let declineDetails = lendingOverview.decline, let reason = declineDetails.declineReason else { return false }
        
        guard reason != ._none else { return false }
        
        return true
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
            let borrowAmount = Double(AppData.shared.amountSelected) ?? 0.0
            guard borrowAmount > 0.0 else {
                showMessage("Please select loan amount", completion: nil)
                return
            }
            AppNav.shared.pushToViewController(StoryboardName.main.rawValue, storyboardId: MainStoryboardId.preview.rawValue, viewController: self)
        }
    }
}


