//
//  UpdateAppVC.swift
//  Cheq
//
//  Created by Amit.Rawal on 02/07/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class UpdateAppVC: UIViewController {

    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        updateBtn.layer.cornerRadius = 27
        backgroundView.backgroundColor = AppConfig.shared.activeTheme.primaryColor
    }

    @IBAction func updateBtnClick(_ sender: Any) {
        let url = URL(string:"https://applink.cheq.com.au/AppStore")!
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
}

