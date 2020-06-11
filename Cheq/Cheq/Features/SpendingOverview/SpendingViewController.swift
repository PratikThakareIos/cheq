//
//  SpendingOverviewViewController.swift
//  Cheq
//
//  Created by XUWEI LIANG on 30/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingViewController: CTableViewController {
    
    override func registerCells() {
        let cellModels: [TableViewCellViewModelProtocol] = [SpacerTableViewCellViewModel(),  HeaderTableViewCellViewModel(), UpcomingBillsTableViewCellViewModel(), InfoNoteTableViewCellViewModel(), TransactionGroupTableViewCellViewModel(), TransactionTableViewCellViewModel(), LineSeparatorTableViewCellViewModel(), SpendingCardTableViewCellViewModel(), BottomTableViewCellViewModel(), TopTableViewCellViewModel()]
        for vm: TableViewCellViewModelProtocol in cellModels {
            let nib = UINib(nibName: vm.identifier, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SpendingViewModel()
        self.setupUI()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.setLeftAlignedNavigationItemTitle(text: ScreenName.spending.rawValue, color: AppConfig.shared.activeTheme.textColor, margin: 30)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        registerObservables()
        if let vm = self.viewModel as? SpendingViewModel, vm.sections.count == 0 {
            NotificationUtil.shared.notify(UINotificationEvent.spendingOverviuew.rawValue, key: "", value: "")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }
    
    func setupUI() {
        hideBackTitle()
        //self.title = ScreenName.spending.rawValue
        self.setLeftAlignedNavigationItemTitle(text: ScreenName.spending.rawValue, color: AppConfig.shared.activeTheme.textColor, margin: 30)
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.addPullToRefreshAction {
            NotificationUtil.shared.notify(UINotificationEvent.spendingOverviuew.rawValue, key: "", value: "")
        }
    }
    
    func registerObservables() {
        setupKeyboardHandling()
        NotificationCenter.default.addObserver(self, selector: #selector(spendingOverview(_:)), name: NSNotification.Name(UINotificationEvent.spendingOverviuew.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.reloadTable.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewAll(_:)), name: NSNotification.Name(UINotificationEvent.viewAll.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(categoryById(_:))
            , name: NSNotification.Name(UINotificationEvent.selectedCategoryById.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTransaction(_:))
            , name: NSNotification.Name(UINotificationEvent.showTransaction.rawValue), object: nil)
    }
}

//MARK: notification handlers
extension SpendingViewController {
    
    func renderSpending(_ spendingOverview: GetSpendingOverviewResponse) {
        // build the spending view model based on response here
        LoggingUtil.shared.cPrint("renderSpending")
        guard let vm = self.viewModel as? SpendingViewModel else { return }
        vm.render(spendingOverview)
    }
    
    @objc func spendingOverview(_ notification: NSNotification) {
        AppConfig.shared.showSpinner()
        
  
        AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
             AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
        }.then { authUser in
            CheqAPIManager.shared.spendingOverview()
        }.done{ overview in
                AppConfig.shared.hideSpinner {
                    print("spending view controller = \(overview)")
                    self.renderSpending(overview)
                    //Manish
                    //self.registerForNotification()
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err) { }
            }
        }
        
        
//        CheqAPIManager.shared.spendingOverview()
//            .done{ overview in
//                AppConfig.shared.hideSpinner {
//                    print("spending view controller = \(overview)")
//                    self.renderSpending(overview)
//                    //Manish
//                    //self.registerForNotification()
//                }
//            }.catch { err in
//                AppConfig.shared.hideSpinner {
//                    self.showError(err) { }
//            }
//        }
    }
    
    @objc func viewAll(_ notification: NSNotification) {
        
        guard let headerTableViewCell = notification.userInfo?[NotificationUserInfoKey.viewAll.rawValue] as? HeaderTableViewCell else { return }
        if headerTableViewCell.tag == HeaderTableViewCellTag.moneySpent.rawValue {
            AppNav.shared.pushToSpendingVC(.categories, viewController: self)
        } else if headerTableViewCell.tag == HeaderTableViewCellTag.recentTransactions.rawValue {
            // show transaction list screen
            AppNav.shared.pushToSpendingVC(.transactions, viewController: self)
        }
    }
    
    
    func registerForNotification(){
        guard let application = AppData.shared.application else { return }
        AuthConfig.shared.activeManager.setupForRemoteNotifications(application, delegate: self)
    }
}
