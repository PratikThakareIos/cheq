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
        self.setupUI()
        setupDelegate()
    }
    override func viewWillAppear(_ animated: Bool) {
          // AppConfig.shared.addEventToFirebase("", "", "", FirebaseEventContentType.screen.rawValue)
         AppConfig.shared.addEventToFirebase(PassModuleScreen.SpendingMoneySpentCategoryDashboard.rawValue, FirebaseEventKey.spend_spent_category_dash.rawValue, FirebaseEventKey.spend_spent_category_dash.rawValue, FirebaseEventContentType.screen.rawValue)
       }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        registerObservables()
        NotificationUtil.shared.notify(UINotificationEvent.spendingTransactions.rawValue, key: "", value: "")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
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
        
        //setupKeyboardHandling()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadTransactions(_:)), name: NSNotification.Name(UINotificationEvent.spendingTransactions.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.reloadTable.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTransactionPopup(_:))
            , name: NSNotification.Name(UINotificationEvent.showTransaction.rawValue), object: nil)
    }
    
    func renderTransactions(_ transactions: [DailyTransactionsResponse]) {
        
        // build the spending view model based on response here
        LoggingUtil.shared.cPrint("renderSpendingCategories")
        guard let vm = self.viewModel as? SpendingTransactionsViewModel else { return }
        vm.render(transactions)
    }
    
    @objc func loadTransactions(_ notification: NSNotification) {
        AppConfig.shared.addEventToFirebase(PassModuleScreen.SpendingCategoryTransactionClick.rawValue, FirebaseEventKey.spend_spent_category_dash_click.rawValue, FirebaseEventKey.spend_spent_category_dash_click.rawValue, FirebaseEventContentType.button.rawValue)
        
        LoggingUtil.shared.cPrint("loadTransactions")
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.spendingTransactions().done { specificCategory in
            AppConfig.shared.hideSpinner {
                self.renderTransactions(specificCategory)
               // [DailyTransactionsResponse]
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @objc func showTransactionPopup(_ notification: NSNotification) {
        AppConfig.shared.addEventToFirebase(PassModuleScreen.SpendingActivity.rawValue, FirebaseEventKey.spend_activity_click.rawValue, FirebaseEventKey.spend_activity_click.rawValue, FirebaseEventContentType.button.rawValue)
        
            LoggingUtil.shared.cPrint("showTransaction")
            guard let transaction = notification.userInfo?[NotificationUserInfoKey.transaction.rawValue] as? TransactionTableViewCell else { return }
            guard let transactionViewModel = transaction.viewModel as? TransactionTableViewCellViewModel else { return }
        
            let response : SlimTransactionResponse = transactionViewModel.data
            self.openRecentActivityPopUpWith(slimTransactionResponse: response)
     }
}

//MARK: -  popup
extension SpendingTransactionsViewController: RecentActivityPopUpVCDelegate{
    
    func recentActivityPopUpClosed() {
        LoggingUtil.shared.cPrint("recentActivityPopUpClosed")
    }
    
    func openRecentActivityPopUpWith(slimTransactionResponse: SlimTransactionResponse?){
       
         self.view.endEditing(true)
        
        guard let _ = slimTransactionResponse else{
            return
        }

        let storyboard = UIStoryboard(name: StoryboardName.Popup.rawValue, bundle: Bundle.main)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: PopupStoryboardId.recentActivityPopUpVC.rawValue) as? RecentActivityPopUpVC{

              popupVC.delegate = self
              popupVC.slimTransactionResponse = slimTransactionResponse
            
              self.tabBarController?.present(popupVC, animated: false, completion: nil)
        }
    }
}
