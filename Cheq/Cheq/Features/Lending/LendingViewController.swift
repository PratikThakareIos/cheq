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
//        if AuthConfig.shared.activeUser != nil {
//            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
//        } else {
//            endToEndSetup()
//        }
        
        TestUtil.shared.loginWithTestAccount().done { authUser in
            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
        }.catch { err in
            self.showError(err, completion: nil)
        }
    }
    
    func endToEndSetup() {
        AppConfig.shared.showSpinner()
        TestUtil.shared.autoSetupAccount().done { authUser in
            AppConfig.shared.hideSpinner {
                // now do Lending API call and refresh tableview
                NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
            }
            }.catch{ err in
                AppConfig.shared.hideSpinner {
                    self.showError(err, completion: nil)
                }
        }
    }

    func setupUI() {
        
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
    }

    
}

// observable handlers
extension LendingViewController {
    
    @objc func reloadTableLayout(_ notification: NSNotification) {
        let _ = notification.userInfo?[NotificationUserInfoKey.cell.rawValue]
        self.tableView.reloadWithoutScroll()
    }
    
    
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
    
    @objc func lendingOverview(_ notification: NSNotification) {
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.lendingOverview().done{ getLendingOverviewResponse in
            let lendingOverview = TestUtil.shared.testLendingOverview()
            AppConfig.shared.hideSpinner {
                
                guard self.declineExist(lendingOverview) == false else {
                    if let declineDetails =  lendingOverview.decline, let declineReason = declineDetails.declineReason {
                        AppData.shared.declineDescription = declineDetails.declineDescription ?? ""
                        AppNav.shared.presentDeclineViewController(declineReason, viewController: self)
                    } else {
                        self.showError(CheqAPIManagerError.errorHasOccurredOnServer, completion: nil)
                    }
                    return
                }
                
                self.viewModel.sections.removeAll()
                var section = TableSectionViewModel()
                LoggingUtil.shared.cPrint("build view model here...")
                
                guard let vm = self.viewModel as?  LendingViewModel else { return }
                // intercom chat
                section.rows.append(IntercomChatTableViewCellViewModel())
                    vm.addLoanSetting(lendingOverview, section: &section)
                    vm.addCashoutButton(lendingOverview, section: &section)
                section.rows.append(SpacerTableViewCellViewModel())
                    vm.completeDetails(lendingOverview, section: &section)
                section.rows.append(SpacerTableViewCellViewModel())
                    // actvity
                    vm.activityList(lendingOverview, section: &section)
                section.rows.append(SpacerTableViewCellViewModel())
                self.viewModel.addSection(section)
                self.registerCells()
                self.tableView.reloadData()
            }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err, completion: nil)
                }
        }
    }
    
    func declineExist(_ lendingOverview: GetLendingOverviewResponse)-> Bool {
        guard let declineDetails = lendingOverview.decline, let _ = declineDetails.declineReason else { return false }
        return true
    }
    
    @objc func button(_ notification: NSNotification) {
        
        guard let button = notification.userInfo?[NotificationUserInfoKey.button.rawValue] as? UIButton else { return }
    
        if button.titleLabel?.text == keyButtonTitle.Cashout.rawValue {
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
