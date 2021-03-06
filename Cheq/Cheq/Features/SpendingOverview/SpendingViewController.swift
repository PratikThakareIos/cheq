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
        setupDelegate()
        showNavBar()
        registerObservables()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.addNotificationsForRemoteConfig()
         RemoteConfigManager.shared.getApplicationStatusFromRemoteConfig()
         AppConfig.shared.addEventToFirebase(PassModuleScreen.Spend.rawValue, FirebaseEventKey.spend_dash.rawValue, FirebaseEventKey.spend_dash.rawValue, FirebaseEventContentType.screen.rawValue)
      //  AppConfig.shared.addEventToFirebase("", "", "", FirebaseEventContentType.screen.rawValue)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        registerObservables()
        self.setLeftAlignedNavigationItemTitle(text: ScreenName.spending.rawValue, color: AppConfig.shared.activeTheme.textColor, margin: 30)
        if let vm = self.viewModel as? SpendingViewModel, vm.sections.count == 0 {
            NotificationUtil.shared.notify(UINotificationEvent.spendingOverviuew.rawValue, key: "", value: "")
        }
        
    }
    override func viewDidLayoutSubviews() {
        self.setLeftAlignedNavigationItemTitle(text: ScreenName.spending.rawValue, color: AppConfig.shared.activeTheme.textColor, margin: 30)
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
        //setupKeyboardHandling()
        NotificationCenter.default.addObserver(self, selector: #selector(spendingOverview(_:)), name: NSNotification.Name(UINotificationEvent.spendingOverviuew.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.reloadTable.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewAll(_:)), name: NSNotification.Name(UINotificationEvent.viewAll.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(categoryById(_:))
            , name: NSNotification.Name(UINotificationEvent.selectedCategoryById.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTransactionPopup(_:))
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
        
        //Manish
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
              self.registerForNotification()
        })
    }
    
    @objc func spendingOverview(_ notification: NSNotification) {
          AppConfig.shared.addEventToFirebase(PassModuleScreen.SpendingMoneySpentCategoryClick.rawValue, FirebaseEventKey.spend_spent_dash_category.rawValue, FirebaseEventKey.spend_spent_dash_category.rawValue, FirebaseEventContentType.button.rawValue)
        LoggingUtil.shared.cPrint("spendingOverview called")
        AppConfig.shared.showSpinner()
        AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
             AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
        }.then { authUser in
            CheqAPIManager.shared.spendingOverview()
        }.done{ overview in
                AppConfig.shared.hideSpinner {
                     LoggingUtil.shared.cPrint("spending view controller = \(overview)")
                    self.renderSpending(overview)
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err) { }
            }
        }
    }
    
    @objc func viewAll(_ notification: NSNotification) {
        guard let headerTableViewCell = notification.userInfo?[NotificationUserInfoKey.viewAll.rawValue] as? HeaderTableViewCell else { return }
        if headerTableViewCell.tag == HeaderTableViewCellTag.moneySpent.rawValue {
            ///user clicks on view all money spent//NNN
            AppConfig.shared.addEventToFirebase(PassModuleScreen.SpendingMoneySpent.rawValue, FirebaseEventKey.spend_spent_view.rawValue, FirebaseEventKey.spend_spent_view.rawValue, FirebaseEventContentType.button.rawValue)
            
            AppNav.shared.pushToSpendingVC(.categories, viewController: self)
        } else if headerTableViewCell.tag == HeaderTableViewCellTag.recentTransactions.rawValue {
             ///user clicks on view all recent activity//NNN
             AppConfig.shared.addEventToFirebase(PassModuleScreen.SpendingActivity.rawValue, FirebaseEventKey.spend_activity_view.rawValue, FirebaseEventKey.spend_activity_view.rawValue, FirebaseEventContentType.button.rawValue)
            // show transaction list screen
            AppNav.shared.pushToSpendingVC(.transactions, viewController: self)
        }
    }
    
    func registerForNotification(){
        guard let application = AppData.shared.application else { return }
        AuthConfig.shared.activeManager.setupForRemoteNotifications(application, delegate: self)
    }
    
    func enableNotification(_ completion: @escaping ()-> Void) {
        LoggingUtil.shared.cPrint("enableNotification")
        AppDelegate.setupRemoteNotifications()
        completion()
    }

}

//MARK: -  popup
extension SpendingViewController: RecentActivityPopUpVCDelegate{
    
    
    @objc func showTransactionPopup(_ notification: NSNotification) {
            LoggingUtil.shared.cPrint("showTransaction")
            guard let transaction = notification.userInfo?[NotificationUserInfoKey.transaction.rawValue] as? TransactionTableViewCell else { return }
            guard let transactionViewModel = transaction.viewModel as? TransactionTableViewCellViewModel else { return }
        
            let response : SlimTransactionResponse = transactionViewModel.data
            self.openRecentActivityPopUpWith(slimTransactionResponse: response)
     }
    
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


//MARK: -  Remote config status Action
extension SpendingViewController {
    
    func addNotificationsForRemoteConfig() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goto_MaintenanceVC(_:)), name: NSNotification.Name(UINotificationEvent.showMaintenanceVC.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.goto_UpdateAppVC(_:)), name: NSNotification.Name(UINotificationEvent.showUpdateAppVC.rawValue), object: nil)
    }
    
    
    @objc func goto_MaintenanceVC(_ notification: NSNotification){
          self.view.endEditing(true)
         AppConfig.shared.hideSpinner {
           AppNav.shared.presentViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.maintenanceVC.rawValue, viewController: self, embedInNav: false, animated: false)
         }
      }
      
       @objc func goto_UpdateAppVC(_ notification: NSNotification){
          self.view.endEditing(true)
          AppConfig.shared.hideSpinner {
             AppNav.shared.presentViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.updateAppVC.rawValue, viewController: self, embedInNav: false, animated: false)
         }
      }
}
