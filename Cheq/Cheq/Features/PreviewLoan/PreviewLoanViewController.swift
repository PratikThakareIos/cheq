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
        
    }
    
    func setupUI() {
        
    }
    
    func registerObservables() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(confirm(_:)), name: NSNotification.Name(UINotificationEvent.swipeConfirmation.rawValue), object: nil)
    }
    
    @objc func confirm(_ notification: NSNotification) {
        LoggingUtil.shared.cPrint("confirm loan")
    }
}
