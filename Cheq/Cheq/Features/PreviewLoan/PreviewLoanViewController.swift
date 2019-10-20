//
//  PreviewLoanViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 19/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PullToRefreshKit

class PreviewLoanViewController: CTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PreviewLoanViewModel()
        setupKeyboardHandling()
        setupUI()
        setupDelegate()
        registerObservables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideBackTitle()
        NotificationUtil.shared.notify(UINotificationEvent.previewLoan.rawValue, key: "", value: "")
    }
    
    func setupUI() {
        self.tableView.addPullToRefreshAction {
            NotificationUtil.shared.notify(UINotificationEvent.previewLoan.rawValue, key: "", value: "")
        }
    }
    
    func registerObservables() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(confirm(_:)), name: NSNotification.Name(UINotificationEvent.swipeConfirmation.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(previewLoan(_:)), name: NSNotification.Name(UINotificationEvent.previewLoan.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableLayout(_:)), name: NSNotification.Name(UINotificationEvent.reloadTableLayout.rawValue), object: nil)
    }
    
    @objc func confirm(_ notification: NSNotification) {
        LoggingUtil.shared.cPrint("confirm loan")
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.borrow().done { _ in
            AppConfig.shared.hideSpinner {
                // return to LendingViewController and load
                // backend should tell LendingViewController to show successfully borrow screen
                self.showMessage("Processed successfully ! :)") {
                    AppNav.shared.dismiss(self)
                }
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
}

extension PreviewLoanViewController {
    
    @objc func previewLoan(_ notification: NSNotification) {

        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.loanPreview().done{ loanPreview in
            AppConfig.shared.hideSpinner {
                self.viewModel.sections.removeAll()
                var section = TableSectionViewModel()
                LoggingUtil.shared.cPrint("build view model here...")
                
                guard let vm = self.viewModel as?  PreviewLoanViewModel else { return }
                section.rows.append(SpacerTableViewCellViewModel())
        
                vm.addTransferToCard(loanPreview, section: &section)
                section.rows.append(SpacerTableViewCellViewModel())
                vm.addRepaymemtCard(loanPreview, section: &section)
                section.rows.append(SpacerTableViewCellViewModel())
                vm.addLoanAgreementCard(loanPreview, section: &section)
                section.rows.append(SpacerTableViewCellViewModel())
                vm.addDirectDebitAgreementCard(loanPreview, section: &section)
                section.rows.append(SpacerTableViewCellViewModel())
                section.rows.append(SpacerTableViewCellViewModel())
                section.rows.append(SwipeToConfirmTableViewCellViewModel())
                section.rows.append(SpacerTableViewCellViewModel())
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
}
