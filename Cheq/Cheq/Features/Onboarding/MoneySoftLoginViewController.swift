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
        var institutionId = ""
        var login: [LoginCredentialType: String] = [:]
        login[.msUsername] = "cheq_01@usecheq.com"
        login[.msPassword] = "cheq01!"
        MoneySoftManager.shared.login(login)
        .then { msAuthModel-> Promise<UserProfileModel> in
            MoneySoftManager.shared.getProfile()
        }.then { profile->Promise<[FinancialInstitutionModel]> in
            MoneySoftManager.shared.getInstitutions()
        }.then { institutions->Promise<InstitutionCredentialsFormModel> in
            let banks: [FinancialInstitutionModel] = institutions
            let selected = banks.first(where: { $0.name == "Demobank"})
            institutionId = String(selected?.financialInstitutionId ?? 0)
            return MoneySoftManager.shared.getBankSignInForm(selected!)
        }.then { credentialsFormModel->Promise<[FinancialAccountLinkModel]> in
            let form: InstitutionCredentialsFormModel = credentialsFormModel
            for promptModel: InstitutionCredentialPromptModel in form.prompts {
                switch(promptModel.type) {
                case .TEXT:
                    promptModel.savedValue = "user01"
                case .PASSWORD:
                    promptModel.savedValue = "user01"
                case .CHECKBOX:
                    break
                }
            }
            return MoneySoftManager.shared.linkableAccounts(institutionId, credentials: form)
        }.done { linkableAccounts in
            print("hello")
        }.catch { err in
            print(err)
        }
    }
}
