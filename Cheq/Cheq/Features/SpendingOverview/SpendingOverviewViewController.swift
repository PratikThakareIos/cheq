//
//  SpendingOverviewViewController.swift
//  Cheq
//
//  Created by XUWEI LIANG on 30/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class SpendingOverviewViewController: UIViewController {

    let viewModel = SpendingOverviewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupKeyboardHandling()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppConfig.shared.showSpinner()
        viewModel.load {
            AppConfig.shared.hideSpinner {
                self.setupUI()
            }
        }
    }

    func setupUI() {
        // TODO: setup + reload UI here
    }
}
