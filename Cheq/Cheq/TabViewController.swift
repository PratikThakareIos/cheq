//
//  TabViewController.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 7/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    let theme = sharedAppConfig.activeTheme

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = sharedAppConfig.activeTheme.backgroundColor
    }


}
