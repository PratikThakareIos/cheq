//
//  CTableViewControllerProtocol.swift
//  Cheq
//
//  Created by Xuwei Liang on 19/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CTableViewController is the parent class for LendingViewController, SpendingViewController, and any other controller that follows the pattern of building the UI through **CTableViewCell**. **CTableViewController** is designed to allow developers to generically create and re-use repeated tableViewCells between various screens.
 */
class CTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /// Please check out the pattern on **Main.storyboard** on how this tableView outlet is setup. The way we setup our tableView needs to be consistent in order for **CTableViewController** to work
    @IBOutlet weak var tableView: UITableView!
    
    /// subclasses of **CTableViewController** should override how they initialize their viewModel. As long as subclass's viewModel extends **BaseTableVCViewModel**
    var viewModel: BaseTableVCViewModel = BaseTableVCViewModel()
    
    /**
     CTableViewController uses automatic tableView height, so we set **estimatedRowHeight** other than 0 to trigger height calculated by the intrinsic value of the table cells. At the end of **ViewDidLoad**, the **registerCells** method is called, this method should be overriden by subclass of **CTableViewController**. **RegisterCells** defines what re-usable cells we want to use in the subclass ViewController.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.estimatedRowHeight = 1
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.registerCells()
    }
    
    /**
     When viewController did disappear, always call **removeObserver** on self, because it can still be in memory inside a navigation stack and handling notification events.
     */
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /**
     setupDelegate simply sets the **delegate**, **dataSource** of tableView to self, this can be done from storyboard, but it's more convenient to do it in **CTableViewController**, which we use as parent class.
     */
    func setupDelegate() {
        guard self.tableView != nil else { return }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

/// common notification event handlers across **CTableViewController** subclasses
extension CTableViewController {
    
    /// handle notification to trigger reload of table
    @objc func reloadTableLayout(_ notification: NSNotification) {
        let _ = notification.userInfo?[NotificationUserInfoKey.cell.rawValue]
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    /// reloading table
    @objc func reloadTable(_ notification: NSNotification) {
        let _ = notification.userInfo?[NotificationUserInfoKey.cell.rawValue]
        reloadTableView(self.tableView)
    }
    
    /// handling the ViewController transition when a **Spending Category** is selected
    @objc func categoryById(_ notification: NSNotification) {
        guard let category = notification.userInfo?[NotificationUserInfoKey.category.rawValue] as? CategoryAmountStatResponse else { return }
        AppData.shared.selectedCategory = category
        // app nav to category id
        let vc = AppNav.shared.initViewController(StoryboardName.main.rawValue, storyboardId: MainStoryboardId.spendingCategoryById.rawValue, embedInNav: false)
        AppNav.shared.pushToViewController(vc, from: self)
    }
    
    /// handling the modal to show **Transaction Details**, **CPopupView** is a wrapper to conveniently do popups. We grab the transaction object from notification first, then extract the **data** from transaction object and apply it to **TransactionModal**
    @objc func showTransaction(_ notification: NSNotification) {
        LoggingUtil.shared.cPrint("showTransaction")
        guard let transaction = notification.userInfo?[NotificationUserInfoKey.transaction.rawValue] as? TransactionTableViewCell else { return }
        guard let transactionViewModel = transaction.viewModel as? TransactionTableViewCellViewModel else { return }
    
        let transactionModal: TransactionModal = UIView.fromNib()
        transactionModal.viewModel.data = transactionViewModel.data
        transactionModal.setupUI()
        let popupView = CPopupView(transactionModal)
        
        popupView.show()
    }
    
    /// if we get notification to open **link**, it is not always just for real web links, there are instances where we use a **link** UI to trigger opening of App setting, trigger logout and any other actions if needed.
    @objc func openWebLink(_ notification: NSNotification) {
        LoggingUtil.shared.cPrint("open link")
        guard let link = notification.userInfo?[NotificationUserInfoKey.link.rawValue] as? String else { return }
        
        // check if it's log out, we treat it differently
        if link == links.logout.rawValue {
            logout()
            return
        }
        
        if link == links.appSetting.rawValue {
            AppNav.shared.pushToAppSetting()
            return 
        }
        
        if link == links.helpAndSupport.rawValue {
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            return
        }
        
        guard let url = URL(string: link) else { return }
        AppNav.shared.pushToInAppWeb(url, viewController: self)
    }
}

extension CTableViewController {
    
    /**
     registerCells method is empty in **CTableViewController**
     make sure subclass is overriding this accordingly. e.g. **SpendingViewController**, **LendingViewController**
     */
    @objc func registerCells() {
        // to be override by subclasses
    }
}

extension CTableViewController {
    
    /// the number of sections is always driven by **[TableSectionViewModel]** in viewModel
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sections.count
    }
    
    /// each **TableSectionViewModel** dictates the number of rows. Rows are array of **CTableViewCell** viewModels that implements **TableViewCellViewModelProtocol**
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section: TableSectionViewModel = self.viewModel.sections[section]
        return section.rows.count
    }
    
    
    /// cellForRow method is where we **dequeue reusable cell** which are registered using **registerCell** method. After we dequeued a **CTableViewCell** subclass, we always firstly set the viewModel, then call **setupConfig** which updates the cell's UI according to its viewModel.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // setup cell
        let section: TableSectionViewModel = self.viewModel.sections[indexPath.section]
        let cellViewModel: TableViewCellViewModelProtocol = section.rows[indexPath.row]
        let cell: CTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.identifier, for: indexPath) as! CTableViewCell
        cell.viewModel = cellViewModel
        cell.setupConfig()
        return cell
    }
}
