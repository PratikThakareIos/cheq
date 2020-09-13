//
//  MedicareCoordinator.swift
//  Cheq
//
//  Created by Alexey on 09.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

struct MedicareCardColorItem: CSegmentedControlItem {
    enum CardColor: String {
        case green
        case yellow
        case blue
    }

    let title: String
    let color: CardColor
    
    var ref: Any? {
        self
    }
}

class MedicareCoordinator: QuestionCoordinatorProtocol {

    static let cardColors = [
            MedicareCardColorItem(title: "Green", color: .green),
            MedicareCardColorItem(title: "Yellow", color: .yellow),
            MedicareCardColorItem(title: "Blue", color: .blue)]
    
    var type: QuestionType = .medicare

    var question: String = "Your Medicare card details"
    var numOfTextFields: Int = 3
    
    var selectedCardColor: MedicareCardColorItem? = MedicareCoordinator.cardColors.first
    
    func segmentedControlConfig() -> (String, [CSegmentedControlItem])? {
        ("Medicare Card Colour", MedicareCoordinator.cardColors)
    }
    
    func onSegmentedControlChange(to selection: CSegmentedControlItem?) {
        if let c = selection as? MedicareCardColorItem {
            selectedCardColor = c
        }
    }
    
    func placeHolder(_ index: Int)->String {
        switch index {
        case 0:
            return "Card Number"
        case 1:
            return "Position on Card"
        case 2:
            return "Valid to"
        default:
            return ""
        }
    }
    
    var hintImage: UIImage? {
        UIImage(named: "ic_medicare_\(selectedCardColor?.color.rawValue ?? "")")
    }
    
    func validateInput(_ inputs: [String: Any]) -> ValidationError? {
        
        guard let firstName = inputs[placeHolder(0)] as? String, let lastName = inputs[placeHolder(1)] as? String else { return ValidationError.allFieldsMustBeFilled }
        
        guard (firstName != "" &&  lastName != "") else {
            return ValidationError.allFieldsMustBeFilled
        }
        
        guard StringUtil.shared.isAlphaOnly(firstName), StringUtil.shared.isAlphaOnly(lastName) else { return ValidationError.onlyAlphabetCharactersIsAllowed }
        
        guard firstName.count >= 2, lastName.count >= 2 else {
            return ValidationError.invalidNameFormat
        }
        
        return nil
    }
}
