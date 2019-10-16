//
//  LendingViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

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
        registerObservables()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let email = CKeychain.shared.getValueByKey(CKey.loggedInEmail.rawValue)
        if email.isEmpty {
            AppConfig.shared.showSpinner()
            TestUtil.shared.autoSetupAccount().done { authUser in
                AppConfig.shared.hideSpinner {
                    // now do Lending API call and refresh tableview
                    NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
                }
            }.catch{ err in
                AppConfig.shared.hideSpinner {
                    self.showError(err, completion: nil)
                }
            }
        } else {
            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
        }
    }
    
    @objc func lendingOverview(_ notification: NSNotification) {
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.lendingOverview().done{ getLendingOverviewResponse in
            AppConfig.shared.hideSpinner {
                var section = TableSectionViewModel()
                LoggingUtil.shared.cPrint("build view model here...")
                
                // intercom chat
                section.rows.append(IntercomChatTableViewCellViewModel())
                self.viewModel.addLoanSetting(getLendingOverviewResponse, section: &section)
                self.viewModel.addCashoutButton(getLendingOverviewResponse, section: &section)
                section.rows.append(SpacerTableViewCellViewModel())
                self.viewModel.completeDetails(getLendingOverviewResponse, section: &section)
                section.rows.append(SpacerTableViewCellViewModel())
                // actvity
                if let activities = getLendingOverviewResponse.borrowOverview?.activities, activities.count > 0 {
                    self.viewModel.activityList(getLendingOverviewResponse, section: &section)
                    section.rows.append(SpacerTableViewCellViewModel())
                }
                
                self.viewModel.addSection(section)
                self.registerCells()
                self.tableView.reloadData()
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }

    func login() {
        var credentials = [LoginCredentialType: String]()
        credentials[.email] = TestUtil.shared.randomEmail()
        credentials[.password] = TestUtil.shared.randomPassword()
        AppConfig.shared.showSpinner()
        AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: credentials).done { authUser in
            AppConfig.shared.hideSpinner {}
        }.catch { err in
            AppConfig.shared.hideSpinner {}
        }
    }

    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.estimatedRowHeight = 1
        self.tableView.rowHeight = UITableView.automaticDimension

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableLayout), name: NSNotification.Name(UINotificationEvent.reloadTableLayout.rawValue), object: nil)
    }

    @objc func reloadTableLayout(_ notification: NSNotification) {
        let _ = notification.userInfo?[NotificationUserInfoKey.cell.rawValue]
        self.tableView.reloadWithoutScroll()
    }

    func setupDelegate() {
        self.tableView.delegate = self
        self.tableView.dataSource = self 
    }

    func registerCells() {
   
        var registered = [String: Bool]()
        for section: TableSectionViewModel in self.viewModel.sections {
            for vm: TableViewCellViewModelProtocol in section.rows {
                if registered[vm.identifier] == nil {
                    let nib = UINib(nibName: vm.identifier, bundle: nil)
                    self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
                    registered[vm.identifier] = true
                }
            }
        }
    }
    
    func registerObservables() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.completeDetails(_:)), name: NSNotification.Name(UINotificationEvent.completeDetails.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.lendingOverview(_:)), name: NSNotification.Name(UINotificationEvent.lendingOverview.rawValue), object: nil)
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
