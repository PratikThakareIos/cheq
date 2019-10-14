//
//  LendingViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class LendingViewController: UIViewController {

    let intercomIdentifier = String(describing: IntercomChatTableViewCell.self)
    let amountSelectIdentifier = String(describing: AmountSelectTableViewCell.self)
    var viewModel = LendingViewModel()
    

    // Complete Details section
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupUI()
        setupDelegate()
        registerCells()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let email = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue) 
        if email.isEmpty {
            self.login()
            return
        }

    }

    func login() {
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = TestUtil.shared.randomEmail()
        credentials[.password] = TestUtil.shared.randomPassword()
        AppConfig.shared.showSpinner()
        AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials).done { authUser in
            AppConfig.shared.hideSpinner {

            }
            }.catch { err in
                AppConfig.shared.hideSpinner {

                }
        }
    }

    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.estimatedRowHeight = 1
        self.tableView.rowHeight = UITableView.automaticDimension

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableLayout), name: NSNotification.Name(UINotificationEvent.reloadTableLayout.rawValue), object: nil)
    }

    @objc func reloadTableLayout(_ notification: NSNotification) {
        self.tableView.reloadWithoutScroll()
    }

    func setupDelegate() {

        NotificationCenter.default.addObserver(self, selector: #selector(self.completeDetails(_:)), name: NSNotification.Name(UINotificationEvent.completeDetails.rawValue), object: nil)

        self.tableView.delegate = self
        self.tableView.dataSource = self 
    }

    func registerCells() {
   
        for vm: TableViewCellViewModelProtocol in self.viewModel.cells {
            LoggingUtil.shared.cPrint(vm.identifier)
            let nib = UINib(nibName: vm.identifier, bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
        }
    }

    @objc func completeDetails(_ notificaton: NSNotification) {
        guard let completeDetailsType = notificaton.userInfo?["type"] as? String else { return }
        let type: CompleteDetailsType = CompleteDetailsType(fromRawValue: completeDetailsType)
        switch type {
        case .workDetails:
            AppData.shared.completingDetailsForLending = true
            AppNav.shared.presentToMultipleChoice(.employmentType, viewController: self)
        case .bankDetils:
            AppData.shared.completingDetailsForLending = true
            // banking details flow
            break
        case .verifyYourDetails: break
            AppData.shared.completingDetailsForLending = true
            // verification flow
            break
        }
    }
}

extension LendingViewController: UITableViewDelegate, UITableViewDataSource {

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
