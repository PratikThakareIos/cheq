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
//        let label = UILabel()
//        //label.text = ScreenName.spending.rawValue
//        //label.textColor = AppConfig.shared.activeTheme.textColor
//        //label.font = AppConfig.shared.activeTheme.headerBoldFont
//        label.textAlignment = .left
//        label.sizeToFit()
 
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        let myString = ScreenName.spending.rawValue
        let myAttribute = [NSAttributedString.Key.foregroundColor:AppConfig.shared.activeTheme.textColor,
                           NSAttributedString.Key.font: AppConfig.shared.activeTheme.headerBoldFont,
                           NSAttributedString.Key.paragraphStyle:style
                          ]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        // set attributed text on a UILabel
//        label.attributedText = myAttrString
//
//        self.navigationItem.titleView = label
        
        self.navigationController?.navigationBar.topItem?.title = "custom name"
        self.navigationController?.navigationBar.titleTextAttributes = myAttribute
    
        
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: label.superview, attribute: .leading, multiplier: 1, constant: 5))
//        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: label.superview, attribute: .centerY, multiplier: 1, constant: 0))


//        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: label.superview, attribute: .centerX, multiplier: 1, constant: 0))
//        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: label.superview, attribute: .width, multiplier: 0.8, constant: 0))
//        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: label.superview, attribute: .centerY, multiplier: 1, constant: 0))
//        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: label.superview, attribute: .height, multiplier: 1, constant: 0))
        
        
    
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
        CheqAPIManager.shared.spendingOverview()
            .done{ overview in
                AppConfig.shared.hideSpinner {
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
            AppNav.shared.pushToSpendingVC(.categories, viewController: self)
        } else if headerTableViewCell.tag == HeaderTableViewCellTag.recentTransactions.rawValue {
            // show transaction list screen
            AppNav.shared.pushToSpendingVC(.transactions, viewController: self)
        }
    }
    
}
