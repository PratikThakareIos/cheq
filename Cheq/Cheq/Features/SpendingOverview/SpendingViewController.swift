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
        let cellModels: [TableViewCellViewModelProtocol] = [SpacerTableViewCellViewModel(),  HeaderTableViewCellViewModel(), UpcomingBillsTableViewCellViewModel(), TransactionGroupTableViewCellViewModel(), SpendingCardTableViewCellViewModel(), BottomTableViewCellViewModel(), TopTableViewCellViewModel()]
        for vm: TableViewCellViewModelProtocol in cellModels {
            let nib = UINib(nibName: vm.identifier, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SpendingViewModel()
        self.setupKeyboardHandling()
        self.setupUI()
        setupDelegate()
        registerObservables()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        NotificationUtil.shared.notify(UINotificationEvent.spendingOverviuew.rawValue, key: "", value: "")
    }
    
    func setupUI() {
        hideBackTitle()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.addPullToRefreshAction {
            NotificationUtil.shared.notify(UINotificationEvent.spendingOverviuew.rawValue, key: "", value: "")
        }
    }
    
    func registerObservables() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(spendingOverview(_:)), name: NSNotification.Name(UINotificationEvent.spendingOverviuew.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.reloadTable.rawValue), object: nil)
    }
}

extension SpendingViewController {
    
    func renderSpending(_ spendingOverview: GetSpendingOverviewResponse) {
        
        // build the spending view model based on response here
        LoggingUtil.shared.cPrint("renderSpending")
        guard let vm = self.viewModel as? SpendingViewModel else { return }
        vm.render(spendingOverview)
    }
    
    @objc func spendingOverview(_ notification: NSNotification) {
        
        let testSpendingOverview = TestUtil.shared.testSpendingOverview()
        self.renderSpending(testSpendingOverview)
//        AppConfig.shared.showSpinner()
//        CheqAPIManager.shared.spendingOverview()
//            .done{ overview in
//                AppConfig.shared.hideSpinner {
//                    //                    let lendingOverview = TestUtil.shared.testLendingOverview()
//                    self.renderSpending(overview)
//                }
//            }.catch { err in
//                AppConfig.shared.hideSpinner {
//                    self.showError(err) {
//                        NotificationUtil.shared.notify(NotificationEvent.logout.rawValue, key: "", object: "")
//                    }
//                }
//        }
    }
}