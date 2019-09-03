//
//  MoneySoftLoginViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 3/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK
import PromiseKit

class MoneySoftLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        runTest()
    }
    
    func runTest() {
        var login: [LoginCredentialType: String] = [:]
        login[.msUsername] = "cheq_01@usecheq.com"
        login[.msPassword] = "cheq01!"
        MoneySoftManager.shared.login(login)
        .then { msAuthModel-> Promise<UserProfileModel> in
            MoneySoftManager.shared.getProfile()
        }.then { profile in
            MoneySoftManager.shared.getInstitutions()
        }.done { institutions in
            print("hello")
        }.catch { err in
            print(err)
        }
    }
}
