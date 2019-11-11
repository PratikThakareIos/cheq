//
//  SpendingCategoryViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 11/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingCategoriesViewController: CTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SpendingCategoriesViewModel()
        self.setupKeyboardHandling()
        self.setupUI()
        setupDelegate()
        registerObservables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        NotificationUtil.shared.notify(UINotificationEvent.spendingCategories.rawValue, key: "", value: "")
    }
    
    func setupUI() {
        hideBackTitle()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.addPullToRefreshAction {
            NotificationUtil.shared.notify(UINotificationEvent.spendingCategories.rawValue, key: "", value: "")
        }
    }
    
    func registerObservables() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(spendingCategories(_:)), name: NSNotification.Name(UINotificationEvent.spendingCategories.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.reloadTable.rawValue), object: nil)
    }
}

extension SpendingCategoriesViewController {
    
    func renderSpendingCategories(_ spendingCategory: GetSpendingCategoryResponse) {
        
        // build the spending view model based on response here
        LoggingUtil.shared.cPrint("renderSpendingCategories")
        guard let vm = self.viewModel as? SpendingCategoriesViewModel else { return }
        vm.render(spendingCategory)
    }
    
    @objc func spendingCategories(_ notification: NSNotification) {

        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.spendingCategories()
            .done{ spendingCategories in
                AppConfig.shared.hideSpinner {
                    self.renderSpendingCategories(spendingCategories)
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err) {
                        NotificationUtil.shared.notify(NotificationEvent.logout.rawValue, key: "", object: "")
                    }
                }
        }
    }
}
