//
//  EmailVerificationViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 12/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class EmailVerificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openMailApp(_ sender: Any) {
        LoggingUtil.shared.cPrint("open mail app")
    }

    @IBAction func next(_ sender: Any) {
        pushToViewController(StoryboardName.common.rawValue, storyboardId: CommonStoryboardId.passcode.rawValue)
    }
}
