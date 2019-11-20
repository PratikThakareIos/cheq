//
//  AccountViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class AccountViewController: CTableViewController {
    
    override func registerCells() {
        let cellModels: [TableViewCellViewModelProtocol] = [SpacerTableViewCellViewModel(), BottomTableViewCellViewModel(), TopTableViewCellViewModel(), AvatarTableViewCellViewModel(), AccountInfoTableViewCellViewModel(), LinkTableViewCellViewModel(), InfoNoteTableViewCellViewModel()]
        for vm: TableViewCellViewModelProtocol in cellModels {
            let nib = UINib(nibName: vm.identifier, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AccountViewModel()
        self.setupKeyboardHandling()
        self.setupUI()
        setupDelegate()
        registerObservables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        if let vm = self.viewModel as? AccountViewModel, vm.sections.count == 0 {
            NotificationUtil.shared.notify(UINotificationEvent.accountInfo.rawValue, key: "", value: "")
        }
    }
    
    func setupUI() {
        hideBackTitle()
        self.title = ScreenName.accountInfo.rawValue
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
    }
    
    func registerObservables() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(accountInfo(_:)), name: NSNotification.Name(UINotificationEvent.accountInfo.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.reloadTable.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openWebLink(_:)), name: NSNotification.Name(UINotificationEvent.openLink.rawValue), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.intercom(_:)), name: NSNotification.Name(UINotificationEvent.intercom.rawValue), object: nil)
    }
}

//MARK: notification handlers
extension AccountViewController {
    
    @objc func accountInfo(_ notification: NSNotification) {
        let vm = self.viewModel as! AccountViewModel
        vm.render()
    }
}

