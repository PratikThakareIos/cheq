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

    var signInForm: InstitutionCredentialsFormModel?
    var selectedBank: FinancialInstitutionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func runTest() {
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
            self.selectedBank = selected
            return MoneySoftManager.shared.getBankSignInForm(selected!)
        }.done { credentialsFormModel in
            let form: InstitutionCredentialsFormModel = credentialsFormModel
            LoggingUtil.shared.cPrint(form)
            self.signInForm = form
            DispatchQueue.main.async {
                self.linkableAccounts()
            }
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
        }
    }
    
    func fillForm(_ form: inout InstitutionCredentialsFormModel) {
        for promptModel: InstitutionCredentialPromptModel in form.prompts {
            switch(promptModel.type) {
            case .TEXT:
                promptModel.savedValue = "user01"
            case .PASSWORD:
                promptModel.savedValue = "user01"
            case .CHECKBOX:
                promptModel.savedValue = "true"
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        runTest()
    }
    
    func linkableAccounts() {
        guard var form = self.signInForm else { return }
        self.fillForm(&form)
        MoneySoftManager.shared.linkableAccounts(String(selectedBank?.financialInstitutionId ?? 0), credentials: form).done { linkableAccounts in
            LoggingUtil.shared.cPrint(linkableAccounts)
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
        }
    }
}
