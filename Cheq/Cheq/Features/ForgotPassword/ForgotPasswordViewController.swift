//
//  ForgotPasswordViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 21/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: CLabel!
    @IBOutlet weak var email: CTextField!
    var viewModel = ForgotPasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        showCloseButton()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.titleLabel.font = AppConfig.shared.activeTheme.headerFont
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        
        self.viewModel.resetEmail = email.text ?? ""
        if let error = self.viewModel.validateInput() {
            showError(error, completion: nil)
            return 
        }
        
        AppData.shared.forgotPasswordEmail = self.viewModel.resetEmail
        self.viewModel.forgotPassword().done { _ in
            LoggingUtil.shared.cPrint("show email verification + new password screen")
        }.catch { err in
            self.showError(err, completion: nil)
        }
    }
}
