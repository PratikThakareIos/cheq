//
//  LoginViewController.swift
//  Cheq
//
//  Created by XUWEI LIANG on 7/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit 

class LoginViewController: UIViewController {

    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        self.view.endEditing(true)
        AppConfig.shared.showSpinner()
        viewModel.login("", password: "").done { authUser in
            AppConfig.shared.hideSpinner {
                LoggingUtil.shared.cPrint(authUser)
                // Load to dashboard
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                if let initialController = storyboard.instantiateInitialViewController() {
                    self.show(initialController, sender: self)
                }
            }
            }.catch { [weak self] err in
                AppConfig.shared.hideSpinner {
                    guard let self = self else { return }
                    self.showError(err, completion: nil)
                }
        }
    }
}
