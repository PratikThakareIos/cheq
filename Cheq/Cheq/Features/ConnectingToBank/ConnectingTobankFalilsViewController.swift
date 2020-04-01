//
//  ConnectingTobankFalilsViewController.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 3/16/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit
import Intercom

class ConnectingTobankFalilsViewController: UIViewController {

    @IBOutlet weak var trytoConnectAgainBtn: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        trytoConnectAgainBtn.layer.cornerRadius = 25
        backgroundView.backgroundColor = AppConfig.shared.activeTheme.primaryColor
    }

    @IBAction func tryTocoeenctAgainBtnClick(_ sender: Any) {
        NotificationUtil.shared.notify(UINotificationEvent.resubmitForm.rawValue, key: "", object: "")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chatWithUsBtnClick(_ sender: Any) {
         IntercomManager.shared.loginIntercom().done { authUser in
             IntercomManager.shared.present()
             }.catch { err in
                 self.showError(err, completion: nil)
         }
    }    
}
