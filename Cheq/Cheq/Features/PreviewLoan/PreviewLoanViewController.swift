//
//  PreviewLoanViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 19/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

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
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.loanPreview().done { preview in
            AppConfig.shared.hideSpinner {
                
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
    
    func setupUI() {
        
    }
    
    func registerObservables() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(confirm(_:)), name: NSNotification.Name(UINotificationEvent.swipeConfirmation.rawValue), object: nil)
    }
    
    @objc func confirm(_ notification: NSNotification) {
        LoggingUtil.shared.cPrint("confirm loan")
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.borrow().done { _ in
            AppConfig.shared.hideSpinner {
                // return to LendingViewController and load
                // backend should tell LendingViewController to show successfully borrow screen
                AppNav.shared.dismiss(self)
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
}
