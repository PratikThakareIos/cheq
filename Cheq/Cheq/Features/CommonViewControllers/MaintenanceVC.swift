//
//  MaintenanceVC.swift
//  Cheq
//
//  Created by Amit.Rawal on 02/07/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class MaintenanceVC: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var lblHeading:UILabel!
    @IBOutlet weak var lblMessage:UILabel!
    @IBOutlet weak var lblVersion:UILabel!
    @IBOutlet weak var imgLogo:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
        
        let message = "We're currently fixing some things to improve your experience. This could take up to a few hours. If you have any questions you can contact us on support@cheq.com.au"
        
        let attributedString = NSMutableAttributedString(string: message)
        let highlightColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha:  0.75)
        attributedString.applyHighlight("support@cheq.com.au", color: highlightColor, font: AppConfig.shared.activeTheme.mediumBoldFont)
        
        self.lblMessage.font = AppConfig.shared.activeTheme.mediumMediumFont
        self.lblMessage.attributedText = attributedString
        self.lblMessage.setLineSpacing(lineSpacing: 6.0)
        if let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.lblVersion.text = "version \(currentAppVersion)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        RemoteConfigManager.shared.getRemoteConfigData().done { _ in
//
//            print(" AppData.shared.remote_isUnderMaintenance = \( AppData.shared.remote_isUnderMaintenance)")
//
//            if (AppData.shared.remote_isUnderMaintenance == false){
//                //self.dismiss(animated: true, completion: nil)
//            }
//
//        }.catch { err in
//            LoggingUtil.shared.cPrint(err)
//        }
        
    }
}


