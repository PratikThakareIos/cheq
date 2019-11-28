//
//  ConnectingToBankViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 28/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class ConnectingToBankViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLabel!
    @IBOutlet weak var descriptionLabel: CLabel! 
    @IBOutlet weak var image: UIImageView!
    var viewModel = ConnectingToBankViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.primaryColor
        self.titleLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        self.titleLabel.font = AppConfig.shared.activeTheme.extraLargeBoldFont
        self.descriptionLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        self.descriptionLabel.font = AppConfig.shared.activeTheme.defaultFont
    }
}
