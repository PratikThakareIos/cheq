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
        let cellModels: [TableViewCellViewModelProtocol] = [SpacerTableViewCellViewModel(),NoMoreActivityViewModel(), HeaderTableViewCellViewModel(), TransactionTableViewCellViewModel(), LineSeparatorTableViewCellViewModel(), BarChartTableViewCellViewModel(), BottomTableViewCellViewModel(), TopTableViewCellViewModel()]
        for vm: TableViewCellViewModelProtocol in cellModels {
            let nib = UINib(nibName: vm.identifier, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SpendingSpecificCategoryViewModel()
        self.setupUI()
        setupDelegate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        registerObservables()
        NotificationUtil.shared.notify(UINotificationEvent.loadCategoryById.rawValue, key: "", value: "")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }
    
    func setupUI() {
        hideBackTitle()
//        self.title = ScreenName.spendingCategoryById.rawValue
        setupSpecificCategoryNavTitle()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.addPullToRefreshAction {
            NotificationUtil.shared.notify(UINotificationEvent.spendingCategories.rawValue, key: "", value: "")
        }
    }
    
    func setupSpecificCategoryNavTitle() {
        
        if let selectedCategory = AppData.shared.selectedCategory {
            let navStackView = CNavStackView()
            let iconName = DataHelperUtil.shared.iconFromCategory(selectedCategory.categoryCode ?? CategoryAmountStatResponse.CategoryCode.others, largeIcon: true)
            let categoryIcon = UIImage(named: iconName)
            let categoryIconImageView = UIImageView(image: categoryIcon)
            navStackView.subViews.append(categoryIconImageView)
            let categoryLabel = CLabel()
            categoryLabel.text = selectedCategory.categoryTitle
            categoryLabel.font = AppConfig.shared.activeTheme.headerBoldFont
            navStackView.addArrangedSubview(categoryIconImageView)
            navStackView.addArrangedSubview(categoryLabel)
            self.navigationItem.titleView = navStackView
//            let testView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
//            testView.backgroundColor = .cyan
//            self.navigationItem.titleView = testView
        } else {
            self.title = ScreenName.spendingCategoryById.rawValue
        }
    }
    
    func registerObservables() {
        
        //setupKeyboardHandling()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadCategoryTransactions(_:)), name: NSNotification.Name(UINotificationEvent.loadCategoryById.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.reloadTable.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTransactionPopup(_:))
            , name: NSNotification.Name(UINotificationEvent.showTransaction.rawValue), object: nil)
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
        CheqAPIManager.shared.spendingCategoryById(AppData.shared.selectedCategory?.categoryId ?? 0).done { specificCategory in
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

//MARK: -  popup
extension SpendingSpecificCategoryViewController: RecentActivityPopUpVCDelegate{
    
    
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
