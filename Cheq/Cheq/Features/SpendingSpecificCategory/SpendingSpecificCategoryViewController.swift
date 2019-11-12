//
//  SpendingSpecificCategoryViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingSpecificCategoryViewController: CTableViewController {

    override func registerCells() {
        let cellModels: [TableViewCellViewModelProtocol] = [SpacerTableViewCellViewModel(),  HeaderTableViewCellViewModel(), TransactionTableViewCellViewModel(), BarChartTableViewCellViewModel(), BottomTableViewCellViewModel(), TopTableViewCellViewModel()]
        for vm: TableViewCellViewModelProtocol in cellModels {
            let nib = UINib(nibName: vm.identifier, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SpendingSpecificCategoryViewModel()
        self.setupKeyboardHandling()
        self.setupUI()
        setupDelegate()
        registerObservables()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        NotificationUtil.shared.notify(UINotificationEvent.loadCategoryById.rawValue, key: "", value: "")
    }
    
    func setupUI() {
        hideBackTitle()
        self.title = ScreenName.spendingCategories.rawValue
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.addPullToRefreshAction {
            NotificationUtil.shared.notify(UINotificationEvent.spendingCategories.rawValue, key: "", value: "")
        }
    }
    
    func registerObservables() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadCategoryTransactions(_:)), name: NSNotification.Name(UINotificationEvent.loadCategoryById.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.reloadTable.rawValue), object: nil)
    }
    
    func renderSpecificCategory(_ spendingCategory: GetSpendingSpecificCategoryResponse) {
        
        // build the spending view model based on response here
        LoggingUtil.shared.cPrint("renderSpendingCategories")
        guard let vm = self.viewModel as? SpendingSpecificCategoryViewModel else { return }
        vm.render(spendingCategory)
    }
    
    @objc func loadCategoryTransactions(_ notification: NSNotification) {
        LoggingUtil.shared.cPrint("loadCategoryTransactions")
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.spendingCategoryById(AppData.shared.selectedCategoryId).done { specificCategory in
            AppConfig.shared.hideSpinner {
                self.renderSpecificCategory(specificCategory)
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
