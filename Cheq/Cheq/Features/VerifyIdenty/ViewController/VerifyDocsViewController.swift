//
//  VerifyDocsViewController.swift
//  Cheq
//
//  Created by Fawaz Faiz on 09/02/2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class VerifyDocsViewController: CTableViewController {
    
    override func registerCells() {
        let cellModels: [TableViewCellViewModelProtocol] = [SpacerTableViewCellViewModel(),  HeaderTableViewCellViewModel(), DocPlaceHolderViewModel(), DocsListPlaceHolder(), DocAccessViewModel()]
        for vm: TableViewCellViewModelProtocol in cellModels {
            let nib = UINib(nibName: vm.identifier, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
     self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
     self.tableView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
    }
}

