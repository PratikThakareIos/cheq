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
    let transparentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transparentView.backgroundColor = .clear
        let rootVc = AppNav.shared.rootViewController()
        rootVc.view.addSubview(transparentView)
        rootVc.view.bringSubviewToFront(transparentView)
        AutoLayoutUtil.pinToSuperview(transparentView, padding: 0.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.transparentView.removeFromSuperview()
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.primaryColor
        self.titleLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        self.titleLabel.font = AppConfig.shared.activeTheme.headerBoldFont
        self.descriptionLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        self.descriptionLabel.font = AppConfig.shared.activeTheme.mediumFont
    }
}
