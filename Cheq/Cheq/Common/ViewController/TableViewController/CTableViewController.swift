//
//  CTableViewControllerProtocol.swift
//  Cheq
//
//  Created by Xuwei Liang on 19/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: BaseTableVCViewModel = BaseTableVCViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.estimatedRowHeight = 1
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        self.registerCells()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupDelegate() {
        guard self.tableView != nil else { return }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension CTableViewController {
    // handle notification to trigger reload of table
    @objc func reloadTableLayout(_ notification: NSNotification) {
        let _ = notification.userInfo?[NotificationUserInfoKey.cell.rawValue]
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    @objc func reloadTable(_ notification: NSNotification) {
        let _ = notification.userInfo?[NotificationUserInfoKey.cell.rawValue]
        reloadTableView(self.tableView)
    }
    
    @objc func categoryById(_ notification: NSNotification) {
        guard let category = notification.userInfo?[NotificationUserInfoKey.category.rawValue] as? CategoryAmountStatResponse else { return }
        AppData.shared.selectedCategory = category
        // app nav to category id
        let vc = AppNav.shared.initViewController(StoryboardName.main.rawValue, storyboardId: MainStoryboardId.spendingCategoryById.rawValue, embedInNav: false)
        AppNav.shared.pushToViewController(vc, from: self)
    }
    
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
    @objc func registerCells() {
        // to be override by subclasses
    }
}

extension CTableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section: TableSectionViewModel = self.viewModel.sections[section]
        return section.rows.count
    }
    
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
