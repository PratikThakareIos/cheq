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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LendingViewModel()
        setupKeyboardHandling()
        setupUI()
        setupDelegate()
        registerObservables()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
    }

    func setupUI() {
        hideBackTitle()
        addLogoutNavButton()
        self.tableView.addPullToRefreshAction {
            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
        }
    }
    
    func registerObservables() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableLayout), name: NSNotification.Name(UINotificationEvent.reloadTableLayout.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.completeDetails(_:)), name: NSNotification.Name(UINotificationEvent.completeDetails.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.lendingOverview(_:)), name: NSNotification.Name(UINotificationEvent.lendingOverview.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.intercom(_:)), name: NSNotification.Name(UINotificationEvent.intercom.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.button(_:)), name: NSNotification.Name(UINotificationEvent.buttonClicked.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showErr(_:)), name: NSNotification.Name(UINotificationEvent.showError.rawValue), object: nil)
    }
}

// observable handlers
extension LendingViewController {
    
    @objc func completeDetails(_ notificaton: NSNotification) {
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
    
    func renderLending(_ lendingOverview: GetLendingOverviewResponse) {
        
        self.showDeclineIfNeeded(lendingOverview)
        
        if self.viewModel.sections.count > 0 {
            self.viewModel.sections.removeAll()
        }
        
        var section = TableSectionViewModel()
        LoggingUtil.shared.cPrint("build view model here...")
        
        guard let vm = self.viewModel as?  LendingViewModel else { return }
        // intercom chat
        section.rows.append(IntercomChatTableViewCellViewModel())
        vm.addLoanSetting(lendingOverview, section: &section)
        vm.addCashoutButton(lendingOverview, section: &section)
        vm.addMessageBubble(lendingOverview, section: &section)
        section.rows.append(SpacerTableViewCellViewModel())
        vm.completeDetails(lendingOverview, section: &section)
        section.rows.append(SpacerTableViewCellViewModel())
        // actvity
        vm.activityList(lendingOverview, section: &section)
        section.rows.append(SpacerTableViewCellViewModel())
        self.viewModel.addSection(section)
        self.tableView.reloadData()
    }
    
    @objc func lendingOverview(_ notification: NSNotification) {
        AppConfig.shared.showSpinner()
            CheqAPIManager.shared.lendingOverview()
            .done{ overview in
                AppConfig.shared.hideSpinner {
//                    let lendingOverview = TestUtil.shared.testLendingOverview()
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
        let eligibleRequirements = lendingOverview.eligibleRequirement
        let kycStatus = eligibleRequirements?.kycStatus ?? .notStarted
        guard eligibleRequirements?.hasBankAccountDetail == true, eligibleRequirements?.hasEmploymentDetail == true, self.kycHasCompleted(kycStatus) else { return false }
        
        guard let declineDetails = lendingOverview.decline, let _ = declineDetails.declineReason else { return false }
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
