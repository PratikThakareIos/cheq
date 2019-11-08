//
//  FinancialInstitutionCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import MobileSDK

struct FinancialInstitutionCoordinator: MultipleChoiceViewModelCoordinator {
    
    let prioritisedBanks = ["Commonwealth Bank", "ANZ", "National Australia Bank", "Westpac"]
    var sectionTitle = Section.bankDetails.rawValue
    var questionTitle = "Choose your bank"
    var coordinatorType: MultipleChoiceQuestionType = .financialInstitutions
    
    func choices() -> Promise<[ChoiceModel]> {
        return financialInstitutions()
    }
    
    func financialInstitutions()-> Promise<[ChoiceModel]> {

        return Promise<[ChoiceModel]>() { resolver in
            AuthConfig.shared.activeManager.getCurrentUser().then {  authUser in
                return MoneySoftManager.shared.login(authUser.msCredential)
            }.then { authUser->Promise<RemoteBankList> in
                return RemoteConfigManager.shared.remoteBanks()
            }.then { remoteBankList->Promise<[FinancialInstitutionModel]> in
                MoneySoftManager.shared.getInstitutions()
            }.then { institutions->Promise<Bool> in
                AppData.shared.financialInstitutions = institutions
                let postFinancialInstitutionsReq = DataHelperUtil.shared.postFinancialInstitutionsRequest(institutions)
                return CheqAPIManager.shared.postBanks(postFinancialInstitutionsReq)
            }.then { success->Promise<[ChoiceModel]> in
                let institutions = AppData.shared.financialInstitutions
                return Promise<[ChoiceModel]>() { res in
                    var result = [ChoiceModel]()
                    
                    
                    
                    for institution:FinancialInstitutionModel in institutions {
                        LoggingUtil.shared.cPrint(institution.image())
                        let institutionName = institution.name ?? ""
                        let mapping = AppData.shared.remoteBankMapping
                        if let remoteBank = mapping[institutionName] {
                            
                            let choice = ChoiceModel(type: .choiceWithIcon, title: institution.name ?? institution.alias ?? "", caption: nil, image: remoteBank.logoUrl, ordering: remoteBank.order, ref: institution)
                            result.append(choice)
                        }
                    }
                    
                    result = result.sorted(by: { $0.ordering <= $1.ordering })
                    res.fulfill(result)
                }
            }.done { choiceList in
                resolver.fulfill(choiceList)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
}

extension FinancialInstitutionCoordinator {
    func shiftPrioritisedBanks(_ names: [String], choices: inout [ChoiceModel]) {
        for choice in choices {
            if names.contains(choice.title) == true {
                choices.bringToFront(item: choice)
            }
        }
    }
}