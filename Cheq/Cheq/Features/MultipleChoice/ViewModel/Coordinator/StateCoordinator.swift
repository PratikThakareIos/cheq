//
//  StateCoordinator.swift
//  Cheq
//
//  Created by Xuwei Liang on 25/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
//import MobileSDK
import PromiseKit

class StateCoordinator: MultipleChoiceViewModelCoordinator {
    
    var sectionTitle = Section.aboutMe.rawValue
    
    var questionTitle = "What is your state address?"
    
    var coordinatorType: MultipleChoiceQuestionType = .state
    
    func choices()-> Promise<[ChoiceModel]> {
        return Promise<[ChoiceModel]>() { resolver in
            let choices = [stateToChoiceModel(nil), stateToChoiceModel(nil), stateToChoiceModel(nil), stateToChoiceModel(nil), stateToChoiceModel(nil), stateToChoiceModel(nil), stateToChoiceModel(nil), stateToChoiceModel(nil)]
            resolver.fulfill(choices)
        }
    }
}

extension StateCoordinator {
    func stateToChoiceModel(_ state: PutUserOnfidoKycRequest?)-> ChoiceModel {
       // let cState = StateCoordinator.convertStateToCState(state)
        return ChoiceModel(type: .choiceWithIcon, title: "", caption: "", image: nil, ordering: 0, ref : nil)
            
    }
    
    static func convertStateToCState(_ state: PutUserOnfidoKycRequest){
//        switch state {
//        case .nsw:
//            return null
//        case .vic:
//            return .cVIC
//        case .qld:
//            return .cQLD
//        case .wa:
//            return .cWA
//        case .sa:
//            return .cSA
//        case .act:
//            return .cACT
//        case .tas:
//            return .cTAS
//        case .nt:
//            return .cNT
//        }
       
    }
    
//    static func convertCStateToPutUserState(_ cState: cState)-> PutUserDetailRequest.State {
//        switch cState {
//        case .cNSW:
//            return .nsw
//        case .cVIC:
//            return .vic
//        case .cQLD:
//            return .qld
//        case .cWA:
//            return .wa
//        case .cSA:
//            return .sa
//        case .cACT:
//            return .act
//        case .cTAS:
//            return .tas
//        case .cNT:
//            return .nt
//        }
//    }
    
    static func convertCStateToState(_ cState: cState) {
//        switch cState {
//        case .cNSW:
//            return .nsw
//        case .cVIC:
//            return .vic
//        case .cQLD:
//            return .qld
//        case .cWA:
//            return .wa
//        case .cSA:
//            return .sa
//        case .cACT:
//            return .act
//        case .cTAS:
//            return .tas
//        case .cNT:
//            return .nt
//        }
    }
}
