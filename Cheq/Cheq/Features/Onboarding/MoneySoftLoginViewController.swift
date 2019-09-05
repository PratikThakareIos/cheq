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
        let login: [LoginCredentialType: String] = MoneySoftUtil.shared.loginAccount()
        MoneySoftManager.shared.login(login)
        .then { msAuthModel-> Promise<UserProfileModel> in
            MoneySoftManager.shared.getProfile()
        }.then { profile->Promise<[FinancialInstitutionModel]> in
            MoneySoftManager.shared.getInstitutions()
        }.then { institutions->Promise<InstitutionCredentialsFormModel> in
            let banks: [FinancialInstitutionModel] = institutions
            banks.forEach { LoggingUtil.shared.cPrint($0.name as! String) }
            let selected = banks.first(where: { $0.name == "St.George Bank"})
            self.selectedBank = selected
            return MoneySoftManager.shared.getBankSignInForm(selected!)
        }.done { credentialsFormModel in
            let form: InstitutionCredentialsFormModel = credentialsFormModel
            LoggingUtil.shared.cPrint(form)
            self.signInForm = form
            DispatchQueue.main.async {
                self.getLinkableAccounts()
            }
            
        }.catch { err in
            LoggingUtil.shared.cPrint(err)
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runTest()
    }
    
//    func linkableAccounts() {
//        var form = MoneySoftUtil.shared.demoBankFormModel()
//        MoneySoftUtil.shared.fillFormWithTestAccount(&form)
//        DispatchQueue.main.async {
//            MoneySoftManager.shared.linkableAccounts(String(form.financialInstitutionId), credentials: form).done { linkableAccounts in
//                LoggingUtil.shared.cPrint(linkableAccounts)
//            }.catch { err in
//                LoggingUtil.shared.cPrint(err)
//            }
//        }
//    }
    
    func getLinkableAccounts() {
        var form = self.signInForm ?? MoneySoftUtil.shared.stgeorgeBankFormModel()
        MoneySoftUtil.shared.fillFormUsingStGeorgeAccount(&form)
        MoneySoftManager.shared.getLinkableAccounts(String(form.financialInstitutionId), credentials: form) { result in
            switch(result) {
            case .success(let accounts):
                LoggingUtil.shared.cPrint(accounts)
            case .failure(let err):
                LoggingUtil.shared.cPrint(err.localizedDescription)
            }
        }
    }
}
