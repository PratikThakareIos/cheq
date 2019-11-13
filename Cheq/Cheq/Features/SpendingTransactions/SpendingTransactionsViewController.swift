//
//  SpendingTransactionsViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 13/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingTransactionsViewController: CTableViewController {

    override func registerCells() {
        let cellModels: [TableViewCellViewModelProtocol] = [SpacerTableViewCellViewModel(),  HeaderTableViewCellViewModel(), TransactionTableViewCellViewModel(), LineSeparatorTableViewCellViewModel(), BarChartTableViewCellViewModel(), BottomTableViewCellViewModel(), TopTableViewCellViewModel()]
        for vm: TableViewCellViewModelProtocol in cellModels {
            let nib = UINib(nibName: vm.identifier, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SpendingTransactionsViewModel()
        self.setupKeyboardHandling()
        self.setupUI()
        setupDelegate()
        registerObservables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        NotificationUtil.shared.notify(UINotificationEvent.spendingTransactions.rawValue, key: "", value: "")
    }
    
    func setupUI() {
        hideBackTitle()
        self.title = ScreenName.spendingTransactions.rawValue
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.addPullToRefreshAction {
            NotificationUtil.shared.notify(UINotificationEvent.spendingTransactions.rawValue, key: "", value: "")
        }
    }
    
    func registerObservables() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadTransactions(_:)), name: NSNotification.Name(UINotificationEvent.spendingTransactions.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.reloadTable.rawValue), object: nil)
    }
    
    func renderTransactions(_ transactions: GetSpendingSpecificCategoryResponse) {
        
        // build the spending view model based on response here
        LoggingUtil.shared.cPrint("renderSpendingCategories")
        guard let vm = self.viewModel as? SpendingTransactionsViewModel else { return }
        vm.render(transactions)
    }
    
    @objc func loadTransactions(_ notification: NSNotification) {
        LoggingUtil.shared.cPrint("loadTransactions")
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.spendingTransactions().done { specificCategory in
            AppConfig.shared.hideSpinner {
                self.renderTransactions(specificCategory)
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}

