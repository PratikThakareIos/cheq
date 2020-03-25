//
//  ConnectingToBankViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 28/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ConnectingToBankViewController is a loading indication screen that is presented when we are doing linking of banks using **MoneySoft SDK**.
 */
class ConnectingToBankViewController: UIViewController {

    @IBOutlet weak var progressBar: CProgressView!
    /// refer to **ConnectingToBankViewController** on **Common** storyboard
    @IBOutlet weak var titleLabel: CLabel!
    @IBOutlet weak var descriptionLabel: CLabel! 
    @IBOutlet weak var image: UIImageView!
    var viewModel = ConnectingToBankViewModel()
    let transparentView = UIView()
    @IBOutlet weak var progressBarContainer: UIView!
    
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
         registerObservables()
    }
    
    func registerObservables() {
        
        setupKeyboardHandling()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.moneysoftEvent.rawValue), object: nil)
       
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.transparentView.removeFromSuperview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }
    func setupUI() {
       
        self.view.backgroundColor = AppConfig.shared.activeTheme.primaryColor
        self.titleLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        self.titleLabel.font = AppConfig.shared.activeTheme.headerBoldFont
        self.descriptionLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        self.descriptionLabel.font = AppConfig.shared.activeTheme.mediumFont
        self.progressBar.setProgress(0.1, animated: true)
        self.progressBar.mode = .gradientMonetary
        self.progressBar.setupConfig()
    }
}

extension ConnectingToBankViewController {
    //Handle Moneysoftevents to update progressbar
    @objc func reloadTable(_ notification: NSNotification) {
       
        guard let category = notification.userInfo?[NotificationUserInfoKey.moneysoftProgress.rawValue] as? Int else { return }

        DispatchQueue.main.async {
              switch category {
                  case 1:
                       self.progressBar.setProgress(0.3, animated: true)
                  case 2:
                       self.progressBar.setProgress(0.75, animated: true)
                  case 3:
                       self.progressBar.setProgress(0.90, animated: true)
                  default:
                       self.progressBar.setProgress(0.3, animated: true)
                  }
        }
      
    }

    
}
